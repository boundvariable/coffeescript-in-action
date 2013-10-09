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


class Product
  products = []   #A
  @find = (query) ->                                       #B
    for product in products                                #B
      product.unmark()                                     #B
    for product in products when product.name is query     #B
      product.mark()                                       #B
      product                                              #B

  constructor: (name, info) ->                           #C
    products.push @                                      #C
    @name = name                                         #C
    @info = info                                         #C
    @view = document.createElement 'div'                 #C
    @view.className = "product #{@category}"             #C
    document.querySelector('.page').appendChild @view    #C
    @view.onclick = =>                                   #C
      @purchase()                                        #C
    @render()                                            #C

  render: ->                                       #D
    show = (for own key, val of @info
      "<div class='info'><strong>#{key}</strong>: #{val}</div>"
    ).join ''
    @view.innerHTML = "#{@name} #{show}"

  purchase: ->                                                        #E
    if @info.stock > 0                                                #E
      post "/json/purchase/#{@category}/#{@name}", (res) =>           #E
        if res.status is "success"                                    #E
          @info = res.update                                          #E
          @render()                                                   #E
  mark: ->                                    #F
    @view.style.border = "3px solid black"    #F

  unmark: ->                       #F
    @view.style.border = "none"    #F


class Camera extends Product
  category: 'camera'
  megapixels: -> @info.megapixels || "Unknown"


class Skateboard extends Product
  category: 'skateboard'
  length: -> @info.length || "Unknown"


class Shop
  constructor: ->
    @render()
    get '/json/list', (data) ->
      for own category of data                #G
        for own name, info of data[category]  #G
          switch category                     #G
            when 'camera'                     #G
              new Camera name, info           #G
            when 'skateboard'                 #G
              new Skateboard name, info       #G

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
