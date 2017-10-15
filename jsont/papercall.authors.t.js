{
  "self": "[\n{$}\n]",
  "self[*]" : "  \{\n    \"name\" : \"{$.name}\",\n    \"avatar\" : \"{$.avatar}\",\n    \"bio\" : {$.bio},\n    \"organization\" : {$.organization},\n    \"country\" : \"\"\n  \},\n",
  "self[*].bio": function(bio) { return JSON.stringify(bio) },
  "self[*].organization": function(bio) { return JSON.stringify(bio) }
}
