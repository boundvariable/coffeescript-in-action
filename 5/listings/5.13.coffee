http = require 'http'
url = require 'url'
coffee = require 'coffee-script'

cameraData  = require('./data.coffee').all  #A

client = ""
require('fs').readFile './5.12', 'utf-8', (err, data) ->           #B
  if err then throw err                                            #B
  client = data                                                    #B
                                                                   #B
css = ""                                                           #B
require('fs').readFile './client.css', 'utf-8', (err, data) ->     #B
  if err then throw err                                            #B
  css = data                                                       #B

headers = (res, status, type) ->
  res.writeHead status, 'Content-Type': "text/#{type}"

view = """
<!doctype html>
<head>
<title>Agtron's Cameras</title>
<link rel='stylesheet' href='/css/client.css'></link>
</head>
<body>
<script src='/js/client.js'></script>
</body>
"""                                                      #C

server = http.createServer (req, res) ->
  path = url.parse(req.url).pathname
  if req.method == "POST"                                               #D
    category = /^\/json\/purchase\/([^/]*)\/([^/]*)$/.exec(path)?[1]    #D
    item = /^\/json\/purchase\/([^/]*)\/([^/]*)$/.exec(path)?[2]        #D
    if category? and item? and cameraData[category][item].stock > 0     #D
      cameraData[category][item].stock -= 1                             #D
      headers res, 200, 'json'                                          #D
      res.write JSON.stringify                                          #D
        status: 'success',                                              #D
        update: cameraData[category][item]                              #D
    else                                                                #D
      res.write JSON.stringify                                          #D
        status: 'failure'                                               #D
    res.end()                                                           #D
    return                                                              #D
  switch path                                  #E
    when '/json/list'                          #E
      headers res, 200, 'json'                 #E
      res.write JSON.stringify cameraData      #E
    when '/js/client.js'                       #E
      headers res, 200, 'javascript'           #E
      res.write coffee.compile client          #E
    when '/css/client.css'                     #E
      headers res, 200, 'css'                  #E
      res.write css                            #E
    when '/'                                   #E
      headers res, 200, 'html'                 #E
      res.write view                           #E
    else                                       #E
      headers res, 404, 'html'                 #E
      res.write '404'                          #E
  res.end()                                    #E

server.listen 8080, '127.0.0.1'
