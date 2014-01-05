{EventEmitter} = require 'events'
WebSocketServer = (require 'websocket').server

seconds = (n) -> n*1000

emitRandomNumbers = (emitter, event, interval) ->
  setInterval ->
    emitter.emit event, Math.floor Math.random()*100
  , interval

source = new EventEmitter
emitRandomNumbers source, 'update', seconds(4)

attachSocketServer = (server) ->
  socketServer = new WebSocketServer httpServer: server
  socketServer.on 'request', (request) ->
    connection = request.accept 'graph', request.origin
    source.on 'update', (data) ->
      console.log 'got update'
      connection.sendUTF JSON.stringify data

exports.attachSocketServer = attachSocketServer