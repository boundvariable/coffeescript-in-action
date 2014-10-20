window.onload = ->                                  #A
  status = document.querySelector '#status'


  render = (buffer) ->                            #B
    status.style.color = 'green'                  #B
    status.style.fontSize = '120px'               #B
    status.innerHTML = buffer[buffer.length-1]    #B

  nextCallbackId = do ->
    callbackId = 0
    -> callbackId = callbackId + 1

  nextCallbackName = ->
    "callback#{nextCallbackId()}"

  fetch = (src, callback) ->                                #C
    head = document.querySelector 'head'                    #C
    newScript = document.createElement 'script'             #C
    newScript.id = 'json-p'                                 #C
    ajaxCallbackName = nextCallbackName()                   #C
    window[ajaxCallbackName] = (data) ->                    #C
      callback data                                         #C
    newScript.src = src + "?callback=#{ajaxCallbackName}"   #C
    lastScript = document.getElementById 'json-p'           #C
    head.removeChild lastScript if lastScript?              #C
    head.appendChild newScript                              #C

  seconds = (n) ->
    1000*n

  framesPerSecond = (n) ->
    (seconds 1)/n

  makeUpdater = (buffer = []) ->                         #D
    bufferRenderer = (json) ->                           #D
      buffer.push (JSON.parse json).hits                 #D
      render buffer                                      #D
                                                         #D
    ->                                                   #D
      window.setInterval ->                              #D
        fetch '/feed.json', bufferRenderer               #D
      , framesPerSecond 20                               #D

   updater = makeUpdater()
   updater()
