# http ommitted from this listing
# get ommitted from this listing
# post ommitted from this listing

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
  template: =>
    """
    <h2>#{@name}</h2>
    <dl>
    <dt>Stock</dt> <dd>#{@info.stock}</dd>
    <dt>New stock arrives in</dt>
    </dl>
    """

  mark: ->
    @view.style.border = "1px solid black";
  unmark: ->
    @view.style.border = "none";

class Gallery
  render: -> "a gallery"

class Camera extends Product
  purchaseCategory: 'camera'
  megapixels: -> @info.megapixels || "Unknown"
  template: ->
    """
    #{@name}: #{@info.stock}
    {@gallery.render()}
    """

class Skateboard extends Product
  purchaseCategory: 'skateboard'
  length: -> @info.length || "Unknown"

class Shop
  constructor: ->
    unless Product::specials?    #A
      Product::specials = []     #A
    @view = document.createElement 'input'
    @view.onchange = ->
      Product.find @value
    document.body.appendChild @view
    @render()
    get '/json/list', (data) ->
      for own category of data
        for own name, info of data[category]
          if info.special?                     #B
            Product::specials.push product     #B
          switch category
            when 'camera'
              new Camera name, info
            when 'skateboard'
              new Skateboard name, info
  render: ->
    @view.innerHTML = ""


shop = new Shop
