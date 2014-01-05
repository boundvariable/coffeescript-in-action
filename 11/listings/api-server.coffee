http = require 'http'
url = require 'url'

handlers = require './handlers'

apiServer = (request, response) ->
  {pathname} = url.parse request.url
  requested = (pathname.split /\//)[1]
  if requested of handlers
    (handlers[requested] request, response)
  else
    response.end handlers.views request, response

exports.makeApiServer = ->
  (http.createServer apiServer).listen 8080, '127.0.0.1'
