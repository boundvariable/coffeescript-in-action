window.onload = ->
  status = document.querySelector '#status'
  graph = document.createElement 'canvas'
  graph.width = window.innerWidth
  graph.height = window.innerHeight
  status.appendChild graph
  context = graph.getContext '2d'

  render = (buffer) ->
    context.fillStyle = 'black'
    context.clearRect 0, 0, graph.width, graph.height
    context.fillRect 0, 0, graph.width, graph.height
    context.lineWidth = 5
    context.strokeStyle = '#5AB946'
    context.beginPath()
    prev = 0
    for y, x in buffer()
      unless y is prev
        context.lineTo 0 + x, 100 + y
      prev = y
    context.stroke()

  seconds = (n) ->
    1000*n

  framesPerSecond = (n) ->
    (seconds 1)/n

  buffer = []

  nextCallbackId = do ->
    callbackId = 0
    -> callbackId = callbackId + 1

  nextCallbackName = ->
    "callback#{nextCallbackId()}"

  fetch = (src, callback) ->
    head = document.querySelector 'head'
    script = document.createElement 'script'
    ajaxCallbackName = nextCallbackName()
    window[ajaxCallbackName] = (data) ->
      callback data
    script.src = src + "?callback=#{ajaxCallbackName}"
    head.appendChild script

  window.setInterval ->
    fetch '/feed.json', (json) ->
      render ->
        buffer.push (JSON.parse json).hits
        if buffer.length is graph.width then buffer.shift()
        buffer
  , framesPerSecond 30
