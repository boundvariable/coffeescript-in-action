assert = require 'assert'

fact = (description, fn) ->
  try
    fn()
    console.log "#{description}: OK"
  catch e
    console.log "#{description}: \n#{e.stack}"


http_double =
  get: (options, callback) ->
    callback "x"
    @
  on: (event, callback) ->

fetch = (topic, callback, http) ->
  options =
    host: 'www.agtronscameras.com'
    port: 80
    path: "/data/#{topic}"

  http.get(options, (result) ->
    callback result
  ).on 'error', (e) ->
    console.log e

parse = (data) ->
  "parsed x"

fact "data is parsed correctly", ->
  parse (parsed) ->
    assert.equal parsed, "parsed x"

fact "data is fetched correctly". ->
  fetch "a-topic", (result) ->
    assert.equal result, "x"
  , http_double

