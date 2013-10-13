
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


class Product
  constructor: (name, info) ->
    @name = name
    @info = info
    @view = document.createElement 'div'
    @view.className = "product #{@category}"
    document.querySelector('.page').appendChild @view
    @view.onclick = =>
      @purchase()
    @render()
  render: ->
    @view.innerHTML = @template()
  purchase: ->
    if @info.stock > 0
      post "/json/purchase/#{@category}/#{@name}", (res) =>
        if res.status is "success"
          @info = res.update
          @render()
  template: =>
    """
    <h2>#{@name}</h2>
    <dl class='info'>
    <dt>Stock</dt>
    <dd>#{@info.stock}</dd>
    <dt>Specials?</dt>
    <dd>#{@specials.join(',') || 'No'}</dd>
    </dl>
    """


class Camera extends Product
  category: 'camera'
  megapixels: -> @info.megapixels || "Unknown"

class Skateboard extends Product
  category: 'skateboard'
  length: -> @info.length || "Unknown"

class Shop
  constructor: ->
    unless Product::specials?                 #A
      Product::specials = []                  #A
    @view = document.createElement 'div'
    @render()
    get '/json/list', (data) ->
      for own category of data
        for own name, info of data[category]
          if info.special?                           #B
            Product::specials.push info.special      #B
          switch category
            when 'camera'
              new Camera name, info
            when 'skateboard'
              new Skateboard name, info
  render: ->
    @view.innerHTML = ""


shop = new Shop
