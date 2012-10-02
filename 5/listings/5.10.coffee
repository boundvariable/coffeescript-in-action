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
  Math.floor Diff/millisecondsInDay    #A

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
    console.log @info
    @view = document.createElement 'div'
    @view.className = "product"
    document.body.appendChild @view
    @view.onclick = =>
      @purchase()
    @render()
  render: -> template()
  purchase: ->
    if @info.stock > 0
      post "/json/purchase/#{@purchaseCategory}/#{@name}", (res) =>
        if res.status is "success"
          @info = res.update
          @render()
  template: =>              #B
    """
    <h2>#{@name}</h2>
    <dl>
    <dt>Stock</dt> <dd>#{@info.stock}</dd>
    <dt>New stock arrives in</dt>
    <dd>#{new Date(@info.arrives).daysFromToday()} days</dd>
    </dl>
    """

  mark: ->
    @view.style.border = "1px solid black";
  unmark: ->
    @view.style.border = "none";

class Gallery                       #C
class Camera extends Product        #C
class Skateboard extends Product    #C
class Shop                          #C

shop = new Shop
