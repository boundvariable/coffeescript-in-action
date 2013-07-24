fs = require 'fs'
http = require 'http'

makeMostRecent = (file1, file2) ->            #A
  mostRecent = 'Nothing read yet.'            #A
                                              #A
  sourceFileWatcher = (fileName) ->           #A
    sourceFileReader = ->                     #A
      fs.readFile fileName, (error, data) ->  #A
        mostRecent = data                     #A
    fs.watch fileName, sourceFileReader       #A
                                              #A
  sourceFileWatcher file1                     #A
  sourceFileWatcher file2                     #A
                                              #A
  getMostRecent = ->                          #A
    mostRecent                                #A


makeServer = ->                                              #B
  mostRecent = makeMostRecent 'file1.txt', 'file2.txt'       #B
                                                             #B
  server = http.createServer (request, response) ->          #B
    response.write mostRecent()                              #B
    response.end()                                           #B
                                                             #B
  server.listen '8080', '127.0.0.1'                          #B

server = makeServer()    #C
