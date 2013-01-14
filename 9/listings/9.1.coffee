fs = require 'fs'
http = require 'http'

readFile = (file, strategy) ->
  fs.readFile file, 'utf-8', (error, response) ->
    throw error if error
    strategy response

readFileAsArray = (file, delimiter, callback) ->
  asArray = (data) ->
    callback data.split(delimiter).slice(0,-1)
  readFile(file, asArray)

compareOnLastName = (a,b) ->
  lastName = (s) ->
    s.split(/\s+/g)[1].replace /,/, ','
  if !a or !b
    1
  else if lastName(a) >= lastName(b)
    1
  else
    -1

sortedCompetitorsFromFile = (fileName, callback) ->
  newline = /\n/gi
  readFileAsArray fileName, newline, (array) ->
    callback array.sort(compareOnLastName)

makeServer = ->
  responseData = ''
  server = http.createServer (request, response) ->
    response.writeHead 200, 'Content-Type': 'text/html'
    response.end JSON.stringify responseData
  server.listen 8888, '127.0.0.1'
  (data) ->
    responseData = data

main = (fileName) ->
  server = makeServer()

  loadData = ->
    console.log 'Loading data'
    sortedCompetitorsFromFile fileName, (data) ->
      console.log 'Data loaded'
      server data
  loadData()
  fs.watchFile fileName, loadData

if process.argv[2]
  main process.argv[2]
  console.log "Starting server on port 8888"
else
  console.log "usage: coffee 9.1.coffee [file]"
