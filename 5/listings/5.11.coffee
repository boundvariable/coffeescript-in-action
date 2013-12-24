class Mixin
  constructor: (methods) ->
    for name, body of methods
      @[name] = body
  include: (klass) ->         #A
    for key, value of @       #A
      klass::[key] = value    #A

htmlRenderer = new Mixin      #B
  render: -> "rendered"       #B

class Camera                  #C
  htmlRenderer.include @      #C

leica = new Camera()

leica.render()      #D
#rendered           #D
