
require 'shelljs/make'
fs = require 'fs'

cirruHtml = require 'cirru-html'

target.html = ->
  entryFile = 'cirru/index.cirru'
  render = cirruHtml.renderer (cat entryFile), '@filename': entryFile
  render().to 'index.html'
  console.log 'updated index.html'

target.watch = ->
  target.html()
  fs.watch 'cirru/', interval: 200, target.html
  exec 'coffee -o js/ -wbc coffee/', async: yes

  fs.watch 'js/', interval: 200, target.browserify

target.browserify = ->
  exec 'browserify -o build/build.js -d js/find.js', ->
    console.log 'browserified'