fs = require 'fs'
http = require 'http'
url = require 'url'
coffee = require 'coffee-script'

data  = require('./data').all       #A
news  = require('./news').all       #A


readClientScript = (callback) ->
  script = "./#{process.argv[2]}.coffee"
  fs.readFile script, 'utf-8', (err, data) ->                      #B
    if err then throw err                                          #B
    callback data                                                  #B

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
<title>Agtron's Emporium</title>
<link rel='stylesheet' href='/css/client.css' />
</head>
<body>
<div class='page'>
<h1>----Agtron&#8217;s Emporium----</h1>
<script src='/js/client.js'></script>
</div>
</body>
</html>
"""                                                      #C

server = http.createServer (req, res) ->
  path = url.parse(req.url).pathname
  if req.method == "POST"                                               #D
    category = /^\/json\/purchase\/([^/]*)\/([^/]*)$/.exec(path)?[1]    #D
    item = /^\/json\/purchase\/([^/]*)\/([^/]*)$/.exec(path)?[2]        #D
    if category? and item? and data[category][item].stock > 0           #D
      data[category][item].stock -= 1                                   #D
      headers res, 200, 'json'                                          #D
      res.write JSON.stringify                                          #D
        status: 'success',                                              #D
        update: data[category][item]                                    #D
    else                                                                #D
      res.write JSON.stringify                                          #D
        status: 'failure'                                               #D
    res.end()                                                           #D
    return                                                              #D
  switch path                                      #E
    when '/json/list'                              #E
      headers res, 200, 'json'                     #E
      res.end JSON.stringify data                  #E
    when '/json/list/camera'                       #E
      headers res, 200, 'json'                     #E
      camera = data.camera                         #E
      res.end JSON.stringify camera                #E
    when '/json/news'                              #E
      headers res, 200, 'json'                     #E
      res.end JSON.stringify news                  #E
    when '/js/client.js'                           #E
      headers res, 200, 'javascript'               #E
      writeClientScript = (script) ->              #E
        res.end coffee.compile(script)             #E
      readClientScript writeClientScript           #E
    when '/css/client.css'                         #E
      headers res, 200, 'css'                      #E
      res.end css                                  #E
    when '/'                                       #E
      headers res, 200, 'html'                     #E
      res.end view                                 #E
    else
      if path.match /^\/images\/(.*)\.png$/gi      #E
        fs.readFile ".#{path}", (err, data) ->     #E
          if err
            headers res, 404, 'image/png'
            res.end()
          else
            headers res, 200, 'image/png'          #E
            res.end data, 'binary'                 #E
      else                                         #E
        headers res, 404, 'html'                   #E
        res.end '404'                              #E


server.listen 8080, '127.0.0.1', ->
  console.log 'Visit http://localhost:8080/ in your browser'
