# http, get and post functions ommitted from this listing

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
      {@gallery.render()}
    """


class Shop
  constructor: ->
    get '/json/list', (data) ->
      for own name, info of data[product_type]


new Shop

Product.find 'aclie'
