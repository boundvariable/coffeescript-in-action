http = require 'http'

{ server } = require './4.9'

{it, stub, describe} = require 'chromic'

businessHit =
  host: 'localhost',
  port: 8080,
  path: '/business/a',
  method: 'GET'

personalHit =
  host: 'localhost',
  port: 8080,
  path: '/personal/a',
  method: 'GET'

for hit in Array 7
  request = http.get businessHit
  request.on 'error', (e) -> console.log e

http.get personalHit
http.get personalHit

indexHit =
  host: 'localhost',
  port: 8080,
  path: '/',
  method: 'GET'

request = http.get indexHit, (response) ->
  result = ''
  response.on 'data', (data) ->
    result += data

  response.on 'end', ->
    describe 'listing 4.9', ->
      it 'should serve number of views', ->
        /Personal: 2/.test(result).shouldBe true
        /Business: 7/.test(result).shouldBe true
        server.close()
