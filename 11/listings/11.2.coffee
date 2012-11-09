assert = require 'assert'

fact = (description, fn) ->
  try
    fn()
    console.log "#{description}: OK"
  catch e
    console.log "#{description}: \n#{e.stack}"


http =                            #A
  get: (options, callback) ->     #A
    callback "canned response"    #A
    @                             #A
  on: (event, callback) ->        #A

fetch = (topic, http, callback) ->
  options =
    host: 'www.agtronscameras.com'
    port: 80
    path: "/data/#{topic}"

  http.get(options, (result) ->
    callback result
  ).on 'error', (e) ->
    console.log e

parse = (data) ->                                #B
  "parsed canned response"                       #B
                                                 #B
fact "data is parsed correctly", ->              #B
  parsed = parse 'canned response'               #B
  assert.equal parsed, "parsed canned response"  #B

fact "data is fetched correctly", ->
  fetch "a-topic", http,  (result) ->
    assert.equal result, "canned response"

