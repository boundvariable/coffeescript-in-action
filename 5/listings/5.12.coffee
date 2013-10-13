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

  post: (src, callback) ->
    @http "POST", src, callback

class View                                                   #A
  @:: = null                                                 #A
  @include = (to, className) =>                              #A
    for key, val of @                                        #A
      to::[key] = val                                        #A
  @handler = (event, fn) ->                                  #A
    @node[event] = fn                                        #A
  @update = ->                                               #A
    unless @node?                                            #A
      @node = document.createElement 'div'                   #A
      @node.className = @constructor.name.toLowerCase()      #A
      document.querySelector('.page').appendChild @node      #A
    @node.innerHTML = @template()                            #A


class Product
  View.include @                       #B
  products = []
  @find = (query) ->
    (product for product in products when product.name is query)
  constructor: (@name, @info) ->
    products.push @
    @template = =>                      #C
      """
      #{@name}
      """
    @update()
    @handler "onclick", @purchase
  purchase: =>
    if @info.stock > 0
      server.post "/json/purchase/#{@category}/#{@name}", (res) =>
        if res.status is "success"
          @info = res.update
          @update()

class Camera extends Product
  category: 'camera'
  megapixels: -> @info.megapixels || "Unknown"


class Skateboard extends Product
  category: 'skateboard'
  length: -> @info.length || "Unknown"


class Shop
  View.include @                 #D
  constructor: ->
    @template = ->               #E
      "<h1>News: #{@breakingNews}</h1>"

    server.get '/json/news', (news) =>
      @breakingNews = news.breaking
      @update()

    server.get '/json/list', (data) ->
      for own category of data
        for own name, info of data[category]
          switch category
            when 'camera'
              new Camera name, info
            when 'skateboard'
              new Skateboard name, info


shop = new Shop
