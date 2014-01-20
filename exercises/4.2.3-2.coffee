css = (element, styles) ->
  element.style ?= {}
  for key, value of styles
    element.style[key] = value

class Element
div = new Element
css div, width: 10

div.style.width
# 10