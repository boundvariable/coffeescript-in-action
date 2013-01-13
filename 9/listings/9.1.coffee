fs = require 'fs'
http = require 'http'

read_file = (file, strategy) ->
  fs.readFile file, 'utf-8', (error, response) ->
    throw error if error
    strategy response

read_file_as_array = (file, delimiter, callback) ->  #A
  as_array = (data) ->                               #A
    callback data.split(delimiter).slice(0,-1)       #A
  read_file(file, as_array)                          #A

compare_on_last_name = (a,b) ->                #B
  last_name = (s) ->                           #B
    s.split(/\s+/g)[1].replace /,/, ','        #B
  if !a or !b                                  #B
    1                                          #B
  else if last_name(a) >= last_name(b)         #B
    1                                          #B
  else                                         #B
    -1                                         #B

sorted_competitors_from_file = (file_name, callback) ->   #C
  newline = /\n/gi                                        #C
  read_file_as_array file_name, newline, (array) ->       #C
    callback array.sort(compare_on_last_name)             #C

make_server = ->                                            #D
  response_data = ''                                        #D
  server = http.createServer (request, response) ->         #D
    response.writeHead 200, 'Content-Type': 'text/html'     #D
    response.end JSON.stringify response_data               #D
  server.listen 8888, '127.0.0.1'                           #D
  (data) ->                                                 #D
    response_data = data                                    #D

main = (file_name) ->
  server = make_server()

  load_data = ->                                         #E
    console.log 'Loading data'
    sorted_competitors_from_file file_name, (data) ->    #E
      console.log 'Data loaded'
      server data                                        #E

  load_data()                                            #E

  fs.watchFile file_name, load_data                      #E

if process.argv[2]                                  #F
  main process.argv[2]                              #F
  console.log "Starting server on port 8888"        #F
else                                                #F
  console.log "usage: coffee 9.1.coffee [file]"     #F
