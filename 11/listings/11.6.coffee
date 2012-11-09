class User
  constructor: (@options, @http) ->    #A
  visitPage: (url, callback) ->
    @options.path = url
    @options.method = 'GET'
    callback()
  clickMouse: (callback) ->                                    #B
    request = @http.request @options, (request, response) ->   #B
      callback()                                               #B
    request.end()                                              #B

exports.User = User
