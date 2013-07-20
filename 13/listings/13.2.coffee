
class Formulaic
  constructor: (@root, @selector, @http) ->
    @subscribers = []
    @fields = @extractFields()
    @startPolling()

  extractFields: ->
    element = @root.querySelector @selector
    fields = element.getElementsByTagName 'input'
    extracted = {}
    for field in fields
      extracted[field.name] = field.value
    extracted

  update: =>
    for own key, value of @extractFields()
      if @fields[key] isnt value
        @fields[key] = value
        @notify()

  startPolling: ->
    setInterval @update, 100

  subscribe: (subscriber) ->
    @subscribers.push subscriber

  notify: ->
    subscriber() for subscriber in @subscribers

  sync: ->
    throw new Error 'No transport' unless @http? and @url?
    @http.post @url, JSON.stringify(@extractFields()), (response) ->
      @fields = JSON.parse response

exports.Formulaic = Formulaic