class Formulaic
  "use strict"
  constructor: (@root, @selector, @http) ->
    @fields = {}
    @subscribers = []
    @extractFields()

  bind: (field) ->
    Object.defineProperty @fields, field.name,
      set: (newValue) =>
        field.value = newValue
        @sync()
      get: ->
        field.value
      enumerable: true

    updateField = =>
      @fields[field.name] = field.value

    updateField()
    field.addEventListener 'input', updateField

  documentFields: ->
    element = @root.querySelector @selector
    element.getElementsByTagName 'input'

  extractFields: ->
    @bind field for field in @documentFields()

  sync: ->
    throw new Error 'No transport' unless @http?
    if @url?
      @http.post @url, JSON.stringify(@fields), (response) =>
        @fields = JSON.parse response

exports.Formulaic = Formulaic
