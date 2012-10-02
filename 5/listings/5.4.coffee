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
  constructor: (name, info) ->           #C
    products.push @                      #C
    @name = name                         #C
    @info = info                         #C
    @view = document.createElement 'div' #C
    @view.className = "product"          #C
    document.body.appendChild @view      #C
    @view.onclick = =>                   #C
      @purchase()                        #C
    @render()                            #C
  render: ->                                       #D
    show = ("<div>#{key}: #{val}</div>" for own key, val of @info).join ''
    @view.innerHTML = "#{@name} #{show}"
  purchase: ->                                                        #E
    if @info.stock > 0                                                #E
      post "/json/purchase/#{@purchaseCategory}/#{@name}", (res) =>   #E
        if res.status is "success"                                    #E
          @info = res.update                                          #E
          @render()                                                   #E
  mark: ->                                    #F
    @view.style.border = "1px solid black"    #F
  unmark: ->                       #F
    @view.style.border = "none"    #F


class Camera extends Product
  purchaseCategory: 'camera'
  megapixels: -> @info.megapixels || "Unknown"


class Skateboard extends Product
  purchaseCategory: 'skateboard'
  length: -> @info.length || "Unknown"


class Shop
  constructor: ->
    @view = document.createElement 'input'
    @view.onchange = ->
      Product.find @value
    document.body.appendChild @view
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
    @view.innerHTML = ""


shop = new Shop
