http = require 'http'

class Tracking
  constructor: (@options, @http) ->     #A
    @pages = []                         #A
  start: (callback) ->                          #B
    @server = @http.createServer @controller    #B
    @server.listen @options.port, callback      #B
  stop: ->             #C
    @server.close()    #C
  controller: (request, response) =>                       #D
    @increment request.url                                 #D
    response.writeHead 200, 'Content-Type': 'text/html'    #D
    response.write ''                                      #D
    response.end()                                         #D
  increment: (key) ->                            #E
    @pages[key] ?= 0                             #E
    @pages[key] = @pages[key] + 1                #E
  total: ->                        #F
    sum = 0                        #F
    for page, count of @pages      #F
      sum = sum + count            #F
    sum                            #F

exports.Tracking = Tracking   #G
