{View} = require './view'

class List extends View
  constructor: (@posts) ->
  render: ->
    all = ("<li><a href='#{post.slug}'>#{post.title}</a></li>" for post in @posts).join ''
    @wrap """
    <ul>#{all}</ul>
    """

exports.List = List
