{
  "self": "[\n{$} \{\}\n]",
  "self[*]" : "  \{\n    \"name\" : \"{$.name}\",\n    \"avatar\" : \"{$.avatar}\",\n    \"bio\" : {$.bio},\n    \"organization\" : {$.organization},\n    \"country\" : \"\",\n    \"id\" : \"{$.email}\"\n  \},\n",
  "self[*].bio": JSON.stringify,
  "self[*].organization": JSON.stringify,
  "self[*].email" : function(s) { var crypto = require('crypto'); return crypto.createHash('md5').update(s).digest('hex') }
}
