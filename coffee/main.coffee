
require.config
  baseUrl: "./"
  paths:
    Ractive: "../bower_components/ractive/Ractive"
    cirru: "../bower_components/cirru-parser/src/parser"
    c2m: "../bower_components/cirru-to-mustache/src/mustache"
    text: "../bower_components/requirejs-text/text"
    cirru_list: "../cirru/list.cr"

require ["./lib/find"]