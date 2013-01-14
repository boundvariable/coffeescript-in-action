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

lastName = (s) ->
  s.split(/\s+/g)[1].replace /,/, ','

decorateSortUndecorate = (array, sort_rule) ->
  decorate = (array) ->
    {original: item, sortOn: sortRule item} for item in array

  undecorate = (array) ->
    item.original for item in array

  comparator = (left, right) ->
    if left.sortOn > right.sortOn
      1
    else
      -1

  decorated = decorate array
  sorted = decorated.sort comparator
  undecorate sorted


sortedCompetitorsFromFile = (fileName, callback) ->
  newline = /\n/gi
  readFileAsArray fileName, newline, (array) ->
    callback decorateSortUndecorate(array, lastName)

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
    start = new Date()
    console.log 'Loading data'
    sortedCompetitorsFromFile fileName, (data) ->
      elapsed = new Date() - start
      console.log "Data loaded in #{elapsed/1000} seconds"
      server data


  loadData()
  fs.watchFile fileName, loadData


start = new Date()
setInterval ->
  console.log "Clock tick at #{(new Date()-start)/1000} seconds"
, 1000


if process.argv[2]
  main process.argv[2]
  console.log "Starting server on port 8888"
else
  console.log "usage: coffee 9.1.coffee [file]"

