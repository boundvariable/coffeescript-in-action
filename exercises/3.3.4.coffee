http = require 'http'
fs = require 'fs'

sourceFile = 'attendees'
fileContents = 'File not read yet.'

readSourceFile = ->
  fs.readFile sourceFile, 'utf-8', (error, data) ->
    if error
      console.log error
    else
      fileContents = data

fs.watchFile sourceFile, readSourceFile

countWords = (text) ->
  text.split(/,/gi).length

readSourceFile sourceFile

server = http.createServer (request, response) ->
  response.end "#{countWords(fileContents)}"

server.listen 8081, '127.0.0.1'
console.log 'Visit http://127.0.0.1:8081 in your browser'
