http = (method, src, callback) ->
  handler = ->
    if @readyState is 4 and @status is 200
      unless @responseText is null
        callback JSON.parse @responseText

  client = new XMLHttpRequest
  client.onreadystatechange = handler
  client.open method, src
  client.send()

get = (src, callback) ->
  http "GET", src, callback

post = (src, callback) ->
  http "POST", src, callback



class Gallery                                                 #A
  constructor: (@photos) ->                                   #A
  render: ->                                                  #A
    images = for photo in @photos                             #A
      "<li><img src='#{photo}' alt='sample photo' /></li>"    #A
    "<ul class='gallery'>#{images.join ''}</ul>"              #A


class Product
  constructor: (name, info) ->                           #B
    @name = name                                         #B
    @info = info                                         #B
    @view = document.createElement 'div'                 #B
    @view.className = 'product'                          #B
    document.querySelector('.page').appendChild @view    #B
    @render()                                            #B
  render: ->
    @view.innerHTML = "#{@name}: #{@info.stock}"


class Camera extends Product
  constructor: (name, info) ->                   #C
    @gallery = new Gallery info.gallery          #C
    super name, info                             #C
    @view.className += ' camera'                 #C
  render: ->
    @view.innerHTML = """
      #{@name} (#{@info.stock})
      #{@gallery.render()}
    """


class Shop
  constructor: ->
    @view = document.createElement 'div'
    document.querySelector('.page').appendChild @view
    document.querySelector('.page').className += ' l55'
    @render()
    get '/json/list', (data) ->
      for own category of data
        for own name, info of data[category]
          switch category
            when 'camera'
              new Camera name, info
            else
              new Product name, info

  render: () ->
    @view.innerHTML = ""

window.onload = ->
  shop = new Shop
