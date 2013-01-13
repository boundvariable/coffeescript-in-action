
{View} = require './view'

fs = require 'fs'

class Js extends View
  src = {} #lets just memoise it!
  constructor: (@file) ->
    unless src[@file]
      src[@file] = fs.readFileSync "#{__dirname}/../client/#{@file}", 'utf-8'
  render: -> src[@file]

exports.Js = Js