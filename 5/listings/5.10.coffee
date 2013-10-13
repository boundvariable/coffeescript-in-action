http = (method, src, callback) ->              #A
  handler = ->                                 #A
    if @readyState is 4 and @status is 200     #A
      unless @responseText is null             #A
        callback JSON.parse @responseText      #A
                                               #A
  client = new XMLHttpRequest                  #A
  client.onreadystatechange = handler          #A
  client.open method, src                      #A
  client.send()                                #A

get = (src, callback) ->                       #B
  http "GET", src, callback                    #B

post = (src, callback) ->                      #C
  http "POST", src, callback                   #C


Date::daysFromToday = ->               #A
  millisecondsInDay = 86400000         #A
  today = new Date                     #A
  diff = @ - today                     #A
  Math.floor diff/millisecondsInDay    #A

class Product
  products = []
  @find = (query) ->
    for product in products
      product.unmark()
    for product in products when product.name is query
      product.mark()
      product
  constructor: (name, info) ->
    products.push @
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
      post "/json/purchase/#{@purchaseCategory}/#{@name}", (res) =>
        if res.status is "success"
          @info = res.update
          @render()
  template: =>              #B
    """
    <h2>#{@name}</h2>
    <dl class='info'>
    <dt>Stock</dt> <dd>#{@info.stock}</dd>
    <dt>New stock arrives in</dt>
    <dd>#{new Date(@info.arrives).daysFromToday()} days</dd>
    </dl>
    """

  mark: ->
    @view.style.border = "1px solid black";
  unmark: ->
    @view.style.border = "none";


class Camera extends Product
  category: 'camera'
  megapixels: -> @info.megapixels || "Unknown"

class Skateboard extends Product
  category: 'skateboard'
  length: -> @info.length || "Unknown"

class Shop
  constructor: ->
    unless Product::specials?
      Product::specials = []
    @view = document.createElement 'div'
    @render()
    get '/json/list', (data) ->
      for own category of data
        for own name, info of data[category]
          if info.special?
            Product::specials.push info.special
          switch category
            when 'camera'
              new Camera name, info
            when 'skateboard'
              new Skateboard name, info

  render: ->
    @view = document.createElement 'div'
    document.querySelector('.page').appendChild @view
    @view.innerHTML = """
    <form class='search'>
    Search: <input id='search' type='text' />
    <button id='go'>Go</button>
    </form>
    """
    console.log @view.innerHTML
    @search = document.querySelector '#search'
    @go = document.querySelector '#go'
    @go.onclick = =>
      Product.find @search.value
      false
    @search.onchange = ->
      Product.find @value
      false


shop = new Shop
