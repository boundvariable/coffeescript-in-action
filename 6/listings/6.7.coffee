beforeAsync = (decoration) ->
  (base) ->
    (params..., callback) ->
      result = undefined
      applyBase = =>
        result = base.apply @, (params.concat callback)
      decoration.apply @, (params.concat applyBase)
      result

afterAsync = (decoration) ->
  (base) ->
    (params..., callback) ->
      decorated = (params...) =>
        decoration.apply @, (params.concat -> (callback.apply @, params))
      base.apply @, (params.concat decorated)
