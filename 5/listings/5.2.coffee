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

class Camera                                              #D
  constructor: (name, info) ->                            #D
    @name = name                                          #D
    @info = info                                          #D
    @view = document.createElement 'div'                  #D
    @view.className = "camera"                            #D
    document.querySelector('.page').appendChild @view     #D
    @view.onclick = =>                                    #D
      @purchase()                                         #D
    @render()                                             #D

  render: ->                                              #D
    @view.innerHTML = """
    #{@name}
    <br/>
    (#{@info.stock} stock)
    """                                                   #D

  purchase: ->                                            #D
    if @info.stock > 0                                    #D
      post "/json/purchase/camera/#{@name}", (res) =>     #D
        if res.status is "success"                        #D
          @info = res.update                              #D
          @render()                                       #D

class Shop                                 #E
  constructor: ->                          #E
    get '/json/list/camera', (data) ->     #E
      for own name, info of data           #E
        new Camera name, info              #E

shop = new Shop
