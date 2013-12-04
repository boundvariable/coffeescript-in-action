assert = require 'assert'

{fact} = require './fact'         #A
{Tracking} = require './10.4'     #B

fact 'controller responds with 200 header and empty body', ->
  request =  url: '/some/url'

  response =                   #C
    write: (body) ->           #C
      @body = body             #C
    writeHead: (status) ->     #C
      @status = status         #C
    end: ->                    #C
      @ended = true            #C

  tracking = new Tracking
  for view in [1..10]
    tracking.controller request, response

  assert.equal response.status, 200              #D
  assert.equal response.body, ''                 #D
  assert.ok response.ended                       #D
  assert.equal tracking.pages['/some/url'], 10   #D


fact 'increments once for each key', ->
  tracking = new Tracking                          #E
  tracking.increment 'a/page' for i in [1..100]    #E
  tracking.increment 'another/page'                #E

  assert.equal tracking.pages['a/page'], 100  #F
  assert.equal tracking.total(), 101          #F

fact 'starts and stops server', ->
  http =                      #G
    createServer: ->          #G
      @created = true         #G
      listen: =>              #G
        @listening = true     #G
      close: =>               #G
        @listening = false    #G

  tracking = new Tracking {}, http    #H
  tracking.start()                    #H

  assert.ok http.listening            #H

  tracking.stop()                     #H
  assert.ok not http.listening        #H
