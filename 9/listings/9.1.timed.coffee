fs = require 'fs'
http = require 'http'

readFile = (file, strategy) ->
  fs.readFile file, 'utf-8', (error, response) ->
    throw error if error
    strategy response

readFileAsArray = (file, delimiter, callback) ->     #A
  asArray = (data) ->                                #A
    callback data.split(delimiter).slice(0,-1)       #A
  readFile(file, asArray)                            #A

compareOnLastName = (a,b) ->                   #B
  lastName = (s) ->                            #B
    s.split(/\s+/g)[1].replace /,/, ','        #B
  if !a or !b                                  #B
    1                                          #B
  else if lastName(a) >= lastName(b)           #B
    1                                          #B
  else                                         #B
    -1                                         #B

sortedCompetitorsFromFile = (fileName, callback) ->       #C
  newline = /\n/gi                                        #C
  readFileAsArray fileName, newline, (array) ->           #C
    callback array.sort(compareOnLastName)                #C

makeServer = ->                                             #D
  responseData = ''                                         #D
  server = http.createServer (request, response) ->         #D
    response.writeHead 200, 'Content-Type': 'text/html'     #D
    response.end JSON.stringify responseData                #D
  server.listen 8888, '127.0.0.1'                           #D
  (data) ->                                                 #D
    responseData = data                                     #D

main = (fileName) ->
  server = makeServer()

  loadData = ->
    start = new Date()
    console.log 'Loading data'
    sortedCompetitorsFromFile fileName, (data) ->
      elapsed = new Date() - start
      console.log "Data loaded in #{elapsed/1000} seconds"
      server data

  loadData()                                            #E
  fs.watchFile fileName, loadData                       #E

if process.argv[2]                                  #F
  main process.argv[2]                              #F
  console.log "Starting server on port 8888"        #F
else                                                #F
  console.log "usage: coffee 9.1.coffee [file]"     #F
