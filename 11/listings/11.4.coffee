window.onload = ->
  status = document.querySelector '#status'

  ensureBars = (number) ->                                          #A
    unless (document.querySelectorAll '.bar').length >= number      #A
      for n in [0..number]                                          #A
        bar = document.createElement 'div'                          #A
        bar.className = 'bar'                                       #A
        bar.style.width = '60px'                                    #A
        bar.style.position = 'absolute'                             #A
        bar.style.bottom = '0'                                      #A
        bar.style.background = 'green'                              #A
        bar.style.color = 'white'                                   #A
        bar.style.left = "#{60*n}px"                                #A
        status.appendChild bar                                      #A

  render = (buffer) ->
    ensureBars 20
    bars = document.querySelectorAll '.bar'
    for bar, index in bars
      bar.style.height = "#{buffer[index]}px"
      bar.innerHTML = buffer[index] || 0

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
