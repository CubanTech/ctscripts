
#!/bin/bash

INSTANCE="$1"
USERNAME="$2"
GITLAB_REPOS_BASEURL="$3"
PATH_GIT="${4:-/srv/scm/git}"

if [ -z "$INSTANCE" -o -z "$USERNAME" -o -z "$GITLAB_REPOS_BASEURL" ]; then
  echo "Usage $0 GITLAB USERNAME BASEURL [PATH]";
  exit 1;
fi

USERNAME_GITLAB=`echo "$USERNAME" | tr '.' '_'`
ACTIVE_USER=`gitlab -g "$INSTANCE" current-user get | cut -d ":" -f2`
ACTIVE_ID=`gitlab -g "$INSTANCE" user list --search $ACTIVE_USER | tr '\n' ':' | sed "s/::/|/g" | tr '|' '\n' | grep "$ACTIVE_USER" | cut -d ':' -f2`

echo "Connecting to $INSTANCE Gitlab as $ACTIVE_USER ($ACTIVE_ID)"
echo "Repositories base URL $GITLAB_REPOS_BASEURL"
echo "Importing $USERNAME repositories"

USERID=`gitlab -g "$INSTANCE" user create --email "$USERNAME@cuban.tech" --password '12345678' --username "$USERNAME_GITLAB" --name "$USERNAME @ github" | grep '^id' | cut -d ':' -f2`

echo "[x] - Create Gitlab user $USERNAME ($USERID) ... ok"

ls -1 $PATH_GIT/$USERNAME | while read REPONAME ; do
  PROJECT_ID=`gitlab -g "$INSTANCE" user-project create --user-id $USERID --name "$REPONAME" --visibility internal --description "Local mirror of https://github.com/$USERNAME/$REPONAME" --issues-enabled false --wiki-enabled true --snippets-enabled false | grep '^id' | cut -d ':' -f2`
  echo "[x] - Create project ($PROJECT_ID) to mirror https://github.com/$USERNAME/$REPONAME ... ok"
  gitlab -g "$INSTANCE" project-member create --project-id $PROJECT_ID --access-level 40 --user-id $ACTIVE_ID > /dev/null
  echo "[x] - Add $ACTIVE_USER ($ACTIVE_ID) as MASTER member in https://github.com/$USERNAME/$REPONAME ... ok"
  cd /srv/scm/git/$USERNAME/$REPONAME
  git remote rm cubantech.lan
  git remote add cubantech.lan "$GITLAB_REPOS_BASEURL/$USERNAME/${REPONAME}.git" && git push cubantech.lan
  echo "[x] - Upload repository to remote $GITLAB_REPOS_BASEURL/$USERNAME/${REPONAME}.git ... ok"
done


