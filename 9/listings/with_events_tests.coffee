{EventEmitter} = require 'events'

withEvents = (emitter, event) ->
  pipeline = []
  data = []

  reset = ->  pipeline = []

  reset()

  run = ->
    result = data
    for processor in pipeline
      if processor.filter?
        result = result.filter processor.filter
      else if processor.map?
        result = result.map processor.map
    result

  emitter.on event, (datum) ->
    data.push datum

  filter: (filter) ->
    pipeline.push {filter}
    @
  map: (map) ->
    pipeline.push {map}
    @
  drain: (fn) ->                   #A
    emitter.on event, (datum) ->   #A
      result = run()               #A
      data = []                    #A
      fn result                    #A
  evaluate: ->
    result = run()
    result
  reset: ->
    reset()


assert = require 'assert'

even = (number) -> number%2 is 0

emitter = new EventEmitter
evenNumberEvents = withEvents(emitter, 'number').filter(even)

emitter.emit 'number', 2
emitter.emit 'number', 5

assert.deepEqual evenNumberEvents.evaluate(), [2]
# [2]

emitter.emit 'number', 4
emitter.emit 'number', 3

assert.deepEqual evenNumberEvents.evaluate(), [2, 4]
# [2, 4]