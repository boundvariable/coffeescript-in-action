assert = require 'assert'
fact = require('./fact').fact
http = require 'http'

{Tracking} = require './10.4'
{User} = require './10.6'

SERVER_OPTIONS =
  host: 'localhost'
  port: 8080

fact 'the tracking application tracks a user mouse click', ->
  tracking = new Tracking SERVER_OPTIONS, http

  tracking.start ->
    assert.equal tracking.total(), 0
    fred = new User SERVER_OPTIONS, http
    fred.visitPage '/some/url', ->
     fred.clickMouse ->
       assert.equal tracking.total(), 1
       tracking.stop()
