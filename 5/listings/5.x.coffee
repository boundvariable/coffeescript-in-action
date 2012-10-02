server =
  http: (method, src, callback) ->
    handler = ->
    if @readyState is 4 and @status is 200
      unless @responseText is null
        callback JSON.parse @responseText

    client = new XMLHttpRequest
    client.onreadystatechange = handler
    client.open method, src
    client.send()

  get: (src, callback) ->
    @http "GET", src, callback

html_renderer =
  render: ->
    @view = document.createElement 'div'
    document.body.appendChild @view
    @view.innerHTML = """
      #{@name}
      #{@info}
    """

class Product
  instances = []
  @find = (name) ->
    (product for product in instances when product.name is name)

  constructor: (name, info) ->
    instances.push @
    @name = name
    @info = info
    @view = document.createElement 'div'
    document.body.appendChild @view
    @render()
  render: ->
    @view.innerHTML = "#{@name}: #{@info.stock}"

class Camera extends Product
  constructor: (name, info) ->
    @name = name
    @info = info
    @gallery = new Gallery
    super
  render: ->
    @view.innerHTML = """
      #{@name}: #{@info.stock}
      {@gallery.render()}
    """


class Shop
  constructor: ->
    server.get '/json/list', (data) ->
      for own name, info of data[product_type]
        if info.special?
          console.log "There's a special"


new Shop

Product.find 'leica'
