chain = (receiver) ->
  wrapper = Object.create receiver         #A
  for key, value of wrapper         #B
    if value?.call                  #C
      do ->                         #D
        proxied = value                     #E
        wrapper[key] = (args...) ->         #F
          proxied.call receiver, args...    #G
          wrapper       #H

  wrapper     #I

turtle =
  forward: (distance) ->
    console.log "moving forward by #{distance}"
  rotate: (degrees) ->
    console.log "rotating #{degrees} degrees"

chain(turtle)    #J
.forward(5)      #J
.rotate(90)      #J
