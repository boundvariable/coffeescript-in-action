window.onload = ->
  status = document.querySelector '#status'
  status.style.width = '640px'
  status.style.height = '480px'
  canvas = document.createElement 'canvas'
  canvas.width = '640'
  canvas.height = '480'
  status.appendChild canvas
  context = canvas.getContext '2d'

  drawTitle = (title) ->
    context.font = 'italic 20px sans-serif'
    context.fillText title

  drawGraph = (buffer) ->
    canvas.width = canvas.width              #A
    context.fillStyle = 'black'
    context.clearRect 0, 0, 640, 480
    context.fillRect 0, 0, 640, 480
    context.lineWidth = 2
    context.strokeStyle = '#5AB946'
    context.beginPath()
    prev = 0
    for y, x in buffer
      unless y is prev
        context.lineTo 0 + x*10, 100 + y
      prev = y
      context.stroke()


  render = (buffer) ->
    drawGraph buffer
    drawTitle 'Server Dashboard'

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

  seconds = (n) ->
    1000*n

  framesPerSecond = (n) ->
    (seconds 1)/n

  makeUpdater = (buffer = []) ->
    bufferRenderer = (json) ->
      buffer.push (JSON.parse json).hits
      if buffer.length is 22 then buffer.shift()
      render buffer

    ->
      window.setInterval ->
        fetch '/feed.json', bufferRenderer
      , framesPerSecond 1

  updater = makeUpdater()
  updater()
