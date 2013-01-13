{Controller} = require '../framework/lib'

fs = require 'fs'

class Static extends Controller

  #@route '/(.*\.js)', 'js'
  #js: (@request, @response, file) =>
  #  'qw'
    ###
    fs.readFile "../client/#{file}", 'utf-8', (err, data) ->
      if err then throw err
      @reponse.writeHead 200, 'Content-Type': 'text/html'
      data
    ###

exports.Static = Static