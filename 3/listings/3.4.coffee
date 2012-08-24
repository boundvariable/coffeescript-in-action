fs = require 'fs'             #1
http = require 'http'         #1

sourceFile = 'myfile'                    #2
fileContents = 'File not read yet.'      #2

readSourceFile = ->                                     #3
  fs.readFile sourceFile, 'utf-8', (error, data) ->     #3
    if error                                            #3
      console.log error                                 #3
    else                                                #3
      bulletin = data                                   #3

fs.watchFile sourceFile, readSourceFile         #4

server = http.createServer (request, response) ->          #5
  response.end fileContents                                #5

server.listen 8080, '127.0.0.1'                            #5
