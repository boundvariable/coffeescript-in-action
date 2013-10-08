
http = (method, src, callback) ->                       #A
  handler = ->
    if @readyState is 4 and @status is 200
      unless @responseText is null
        callback JSON.parse @responseText

  client = new XMLHttpRequest
  client.onreadystatechange = handler
  client.open method, src
  client.send()

get = (src, callback) ->                       #B
  http "GET", src, callback

post = (src, callback) ->                      #B
  http "POST", src, callback


class Product
  constructor: (name, info) ->                            #C
    @name = name                                          #C
    @info = info                                          #C
    @view = document.createElement 'div'                  #C
    @view.className = "product"                           #C
    document.body.appendChild @view                       #C
    @view.onclick = =>                                    #C
      @purchase()                                         #C
    @render()                                             #C
  render: ->
    renderInfo = (key,val) ->
      "<div>#{key}: #{val}</div>"
    displayInfo = (renderInfo(key, val) for own key, val of @info)     #D
    @view.innerHTML = "#{@name} #{displayInfo.join ''}"                #D
  purchase: ->                                                         #D
    if @info.stock > 0                                                 #D
      post "/json/purchase/#{@purchase_category}/#{@name}", (res) =>   #D
        if res.status is "success"                                     #D
          @info = res.update                                           #D
          @render()                                                    #D

class Camera extends Product
  purchaseCategory: 'camera'
  megapixels: -> @info.megapixels || "Unknown"


class Skateboard extends Product
  purchaseCategory: 'skateboard'
  length: -> @info.length || "Unknown"


class Shop                                       #E
  constructor: ->                                #E
    get '/json/list', (data) ->                  #E
      for own category of data                   #E
        for own name, info of data[category]     #E
          switch category                        #E
            when 'camera'                        #E
              new Camera name, info              #E
            when 'skateboard'                    #E
              new Skateboard name, info          #E

shop = new Shop
