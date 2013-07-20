class Formulaic
  "use strict"                               #A
  constructor: (@root, @selector, @http) ->
    @fields = {}
    @extractFields()

  bind: (field) ->
    Object.defineProperty @fields, field.name,
    set: (newValue) =>
      field.value = newValue
      @sync()
    get: ->
      field.value
    enumerable: true
    configurable: true

    updateField = =>
      @fields[field.name] = field.value

    updateField()
    field.addEventListener 'input', updateField

  disable: ->
    for key, value of @fields
      Object.defineProperty @fields, key, { value }
    for field in @documentFields()
      field.disabled = true

    Object.freeze @fields

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
