{
  "self": "[\n{$} \{\}\n]",
  "self[*]" : "  \{\n    \"talk_format\" : \"{$.talk_format}\",\n    \"title\" : \"{$.title}\",\n    \"abstract\" : {$.abstract},\n    \"description\" : {$.description},\n    \"audience_level\" : \"{$.audience_level}\",\n    \"author_id\" : \"{$.email}\",\n    \"tags\" : {$.tags},\n    \"id\" : \"{$.created_at}\"\n  \},\n",
  "self[*].abstract": JSON.stringify,
  "self[*].description": JSON.stringify,
  "self[*].email" : function(s) { var crypto = require('crypto'); return crypto.createHash('md5').update(s).digest('hex') },
  "self[*].created_at" : function(s) { var crypto = require('crypto'); return crypto.createHash('md5').update(s).digest('hex') },
  "self[*].tags" : "[{$} \"\"]",
  "self[*].tags[*]" : "\"{$}\",",
}
