class Product
  # any implementation of Product

class Camera extends Product
  cameras = []
  @alphabetical = ->
    cameras.sort (a, b) -> a.name > b.name
  constructor: ->
    all.push @
    super
