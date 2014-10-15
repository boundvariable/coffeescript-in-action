find = (name) ->                      #A
  document.querySelector ".#{name}"   #A

color = (element, color) ->             #B
  element.style.background = color      #B

insert = (teams...) ->                      #C
  root = document.querySelector '.teams'    #C
  for team in teams                         #C
    element = document.createElement 'li'   #C
    element.innerHTML = team                #C
    element.className = team                #C
    root.appendChild element                #C

highlight = (first, rest...) ->    #D
  color find(first), 'gold'        #D
  for name in rest                 #D
    color find(name), 'blue'       #D

initialize = (ranked) ->         #E
  insert ranked...               #E
  highlight ranked...

window.onload = ->    #F
  initialize [        #F
    'wolverines'      #F
    'wildcats'        #F
    'mongooses'       #F
  ]                   #F
