http = require 'http'
assert = require 'assert'


requestTopicData = (http, topic, callback) ->
  options =
    host: 'www.boundvariable.com'
    port: 80
    path: "/data/#{topic}"

  http.get(options, (res) ->
    callback res
  ).on 'error', (e) ->
    console.log e

expected =
  a: 'a'
  b: 'b'

originalRequestTopicData = requestTopicData

requestTopicData = (topic, callback) ->
  fakeHttp =
    get: (options, callback) ->
      callback expected
      on: ->

  originalRequestTopicData fake_http, topic, callback

exports.requestTopicData = requestTopicData