{
  "self": "[\n{$} \{\}\n]",
  "self[*]" : "  \{\n    \"talk_format\" : \"{$.talk_format}\",\n    \"title\" : \"{$.title}\",\n    \"abstract\" : {$.abstract},\n    \"description\" : {$.description},\n    \"audience_level\" : \"{$.audience_level}\",\n    \"author_id\" : \"{$.email}\",\n    \"tags\" : {$.tags},\n    \"id\" : \"{$.created_at}\"\n  \},\n",
  "self[*].abstract": JSON.stringify,
  "self[*].description": JSON.stringify,
  "self[*].email" : hash('md5'),
  "self[*].created_at" : hash('md5'),
  "self[*].tags" : "[{$} \"\"]",
  "self[*].tags[*]" : "\"{$}\",",
}
