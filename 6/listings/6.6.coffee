before = (decoration) ->
  (base) ->
    (params...) ->
      decoration.apply @, params
      base.apply @, params

after  = (decoration) ->
  (base) ->
    (params...) ->
      result = base.apply @, params
      decoration.apply @, params
      result

around = (decoration) ->
  (base) ->
    (params...) ->
      result = undefined
      func = => result = base.apply @, params
      decoration.apply @, ([func].concat params)
      result

## Example
class Robot
  withRunningEngine = around (action) ->
    @startEngine()
    action()
    @stopEngine()
  constructor: (@at = 0) ->
  position: ->
    @at
  move: (displacement) ->
    console.log 'move'
    @at += displacement
  startEngine: -> console.log 'start engine'
  stopEngine: -> console.log 'stop engine'
  forward: withRunningEngine ->
    @move 1
  reverse: withRunningEngine ->
    @move -1
  wasteFuel: withRunningEngine ->
    console.log 'Wasting fuel'
    'Fuel wasted'


bender = new Robot 3
bender.forward()
# start engine
# move
# stop engine

bender.forward()
# start engine
# move
# stop engine

bender.reverse()
# start engine
# move
# stop engine
assert = require 'assert'
assert.deepEqual bender.position(), 4
# 4

assert.equal bender.wasteFuel(), 'Fuel wasted'