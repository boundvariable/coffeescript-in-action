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
      callback = =>
        result = base.apply @, params
      decoration.apply @, ([callback].concat params)
      result
