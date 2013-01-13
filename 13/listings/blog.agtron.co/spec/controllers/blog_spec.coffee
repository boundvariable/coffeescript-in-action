http = require 'http'

{describe, it} = require 'chromic'
{Blog} = require '../../app/controllers'
{Post} = require '../../app/models'

describe 'Blog controller', ->
  server = {}
  blog = {}
  response = {}
  setup = ->
    server = new http.Server
    blog = new Blog server
    response = (new http.ServerResponse {}).double

  it 'should write headers and end response', ->
    setup()

    response.should_receive 'writeHead'
    response.should_receive 'end'

    server.emit 'request', url: '/', response
