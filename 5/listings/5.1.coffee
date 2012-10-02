class Camera
  constructor: (name, info) ->    #A
    @name = name                  #A
    @info = info                  #A
  render: ->                                                            #B
    "Camera: #{@name}: #{@info.description} (#{@info.stock} in stock)"  #B
  purchase: -> #C
