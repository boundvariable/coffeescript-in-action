http = require 'http'

class Views
  constructor: ->
    @pages = {}
  increment: (key) ->
    @pages[key] ?= 0
    @pages[key] = @pages[key] + 1
  total: ->
    sum = 0
    for own url, count of @pages
      sum = sum + count
    sum

businessViews = new Views
personalViews = new Views

server = http.createServer (request, response) ->
  renderHit = (against) ->
    against.increment request.url
    response.writeHead 200, 'Content-Type': 'text/html'
    response.end "recorded"

  if request.url is '/'
    response.writeHead 200, 'Content-Type': 'text/html'
    response.end """
       Personal: #{personalViews.total()}
       Business: #{businessViews.total()}
    """
  else if /\/business\/.*/.test request.url
    renderHit businessViews
  else if /\/personal\/.*/.test request.url
    renderHit personalViews
  else
    response.writeHead 404, 'Content-Type': 'text/html'
    response.end "404"


server.listen 8080, '127.0.0.1'

exports.server = server
