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

  startPolling: ->
    diff = =>
      for own key, value of @extractFields()
        if @fields[key] isnt value
          @fields[key] = value
          @notify()
    setInterval diff, 100

  subscribe: (subscriber) ->
    @subscribers.push subscriber

  notify: ->
    subscriber() for subscriber in @subscribers
