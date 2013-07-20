{EventEmitter} = require 'events'
WebSocketServer = (require 'websocket').server       #A

seconds = (n) -> n*1000

emitRandomNumbers = (emitter, event, interval) ->
  setInterval ->
    emitter.emit event, Math.floor Math.random()*100
  , interval

source = new EventEmitter
emitRandomNumbers source, 'update', seconds(4)

attachSocketServer = (server) ->                                #B
  socketServer = new WebSocketServer httpServer: server         #B
  socketServer.on 'request', (request) ->                       #B
    connection = request.accept 'graph', request.origin         #B
    source.on 'update', (data) ->                               #B
      connection.sendUTF JSON.stringify data                    #B

exports.attachSocketServer = attachSocketServer
