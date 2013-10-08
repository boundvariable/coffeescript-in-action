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



class Gallery               #A
  render: -> "a gallery"    #A

class Product
  instances = []
  @find = (name) ->
    (product for product in instances when product.name is name)

  constructor: (name, info) ->            #B
    instances.push @                      #B
    @name = name                          #B
    @info = info                          #B
    @view = document.createElement 'div'  #B
    document.body.appendChild @view       #B
    @render()                             #B
  render: ->
    @view.innerHTML = "#{@name}: #{@info.stock}"

class Camera extends Product
  constructor: (name, info) ->       #C
    @gallery = new Gallery           #C
    super(name, info)                #C
  render: ->
    @view.innerHTML = """
      #{@name}: #{@info.stock}
      #{@gallery.render()}
    """


class Shop
  constructor: ->
    @view = document.createElement 'div'
    document.body.appendChild @view
    @render()
    get '/json/list', (data) ->
      for own category of data
        for own name, info of data[category]
          switch category
            when 'camera'
              new Camera name, info

  render: () ->
    @search = document.createElement 'input'
    @searchResults = document.createElement 'div'
    @search.onchange = =>
      results = Product.find @value
      if results.length > 0
        @view.innerHTML = """
        Found: #{results.join ','}
        """
      else
        @view.innerHTML = "Nothing found"
      false

    @view.innerHTML = ""
    document.body.appendChild @search


new Shop

# Product.find 'aclie'
