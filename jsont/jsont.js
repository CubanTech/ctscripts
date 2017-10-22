
/*  This work is licensed under Creative Commons GNU LGPL License.

  License: http://creativecommons.org/licenses/LGPL/2.1/
   Version: 0.9
  Author:  Stefan Goessner/2006
  Web:     http://goessner.net/ 
*/

function jsonT(self, rules) {
   var T = {
      output: false,
      init: function() {
         for (var rule in rules)
            if (rule.substr(0,4) != "self")
               rules["self."+rule] = rules[rule];
         return this;
      },
      apply: function(expr) {
         var trf = function(s){ return s.replace(/{([A-Za-z0-9_\$\.\[\]\'@\(\)]+)}/g, 
                                  function($0,$1){return T.processArg($1, expr);})},
             x = expr.replace(/\[[0-9]+\]/g, "[*]"), res;
         if (x in rules) {
            if (typeof(rules[x]) == "string")
               res = trf(rules[x]);
            else if (typeof(rules[x]) == "function")
               res = trf(rules[x](eval(expr)).toString());
         }
         else 
            res = T.eval(expr);
         return res;
      },
      processArg: function(arg, parentExpr) {
         var expand = function(a,e){return (e=a.replace(/^\$/,e)).substr(0,4)!="self" ? ("self."+e) : e; },
             res = "";
         T.output = true;
         if (arg.charAt(0) == "@")
            res = eval(arg.replace(/@([A-za-z0-9_]+)\(([A-Za-z0-9_\$\.\[\]\']+)\)/, 
                                   function($0,$1,$2){return "rules['self."+$1+"']("+expand($2,parentExpr)+")";}));
         else if (arg != "$")
            res = T.apply(expand(arg, parentExpr));
         else
            res = T.eval(parentExpr);
         T.output = false;
         return res;
      },
      eval: function(expr) {
         var v = eval(expr), res = "";
         if (typeof(v) != "undefined") {
            if (v instanceof Array) {
               for (var i=0; i<v.length; i++)
                  if (typeof(v[i]) != "undefined")
                     res += T.apply(expr+"["+i+"]");
            }
            else if (typeof(v) == "object") {
               for (var m in v)
                  if (typeof(v[m]) != "undefined")
                     res += T.apply(expr+"."+m);
            }
            else if (T.output)
               res += v;
         }
         return res;
      }
   };
   return T.init().apply("self");
}


/**
 * Command line command to transform JSON files.
 */

var path_input = process.argv[2]
var path_template = process.argv[3]
var path_output = process.argv[4]

var fs = require('fs')

/**
 * Helpers
 */

function hash(method) {
  return function (s) {
    return require('crypto').createHash(method).update(s).digest('hex')
  }
}

function render_template(path_template) {
  var template = fs.readFileSync(path_template).toString()
  template = eval('template = ' + template)
  console.log('Instantiate template ...')
  return function (input_data) {
    out = jsonT(input_data, template)
    console.log('Parsing as JSON ...')
    try {
      var out = JSON.parse(out)
      if (out[0].id) {
        var cache = {}
        var new_out = []
        for (var i = 0; i < out.length; ++i) {
          var item = out[i]
          if (!cache[item.id]) {
            new_out.push(item)
          }
          cache[item.id] = item
        }
        console.log('JSON data ' + out.length + ' => ' + new_out.length)
        out = new_out
      }
      out = JSON.stringify(out, null, 2)
    }
    catch(e) {
      console.log('JSON parsing failed' + e.message)
    }
    return out
  }
}

fs.readFile(path_input, function(err, input_data) {
  input_data = JSON.parse(input_data)
  console.log('Loaded input file ...')
  var out = render_template(path_template)(input_data)
  fs.writeFile(path_output, out.toString(), function(err) {
    if (err) {
      console.log(err)
      return
    }
    console.log('Success!')
  })
})

