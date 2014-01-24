fs = require 'fs'
http = require 'http'
url = require 'url'
coffee = require 'coffee-script'

class ShopServer
  constructor: (@host, @port, @shopData, @shopNews) ->
    @css = ''
    fs.readFile './client.css', 'utf-8', (err, data) =>
      if err then throw err
      @css = data

  readClientScript: (callback) ->
    script = "./client.coffee"
    fs.readFile script, 'utf-8', (err, data) ->
      if err then throw err
      callback data

  headers: (res, status, type) ->
    res.writeHead status, 'Content-Type': "text/#{type}"

  renderView: ->
    """
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
    """

  handleClientJs: (path, req, res) ->
    @headers res, 200, 'javascript'
    writeClientScript = (script) ->
      res.end coffee.compile(script)
    @readClientScript writeClientScript

  handleClientCss: (path, req, res) ->
      @headers res, 200, 'css'
      res.end @css

  handleImage: (path, req, res) ->
    fs.readFile ".#{path}", (err, data) =>
      if err
        @headers res, 404, 'image/png'
        res.end()
      else
        @headers res, 200, 'image/png'
        res.end data, 'binary'

  handleJson: (path, req, res) ->
    switch path
      when '/json/list'
        @headers res, 200, 'json'
        res.end JSON.stringify(@shopData)
      when '/json/list/camera'
        @headers res, 200, 'json'
        camera = @shopData.camera
        res.end JSON.stringify(camera)
      when '/json/news'
        @headers res, 200, 'json'
        res.end JSON.stringify(@shopNews)
      else
        @headers res, 404, 'json'
        res.end JSON.stringify(status: 404)

  handlePost: (path, req, res) ->
    category = /^\/json\/purchase\/([^/]*)\/([^/]*)$/.exec(path)?[1]
    item = /^\/json\/purchase\/([^/]*)\/([^/]*)$/.exec(path)?[2]
    if category? and item? and data[category][item].stock > 0
      data[category][item].stock -= 1
      @headers res, 200, 'json'
      res.write JSON.stringify
        status: 'success',
        update: data[category][item]
    else
      res.write JSON.stringify
        status: 'failure'
    res.end()

  handleGet: (path, req, res) ->
    if path is '/'
      @headers res, 200, 'html'
      res.end @renderView()
    else if path.match /\/json/
      @handleJson path, req, res
    else if path is '/js/client.js'
      @handleClientJs path, req, res
    else if path is '/css/client.css'
      @handleClientCss path, req, res
    else if path.match /^\/images\/(.*)\.png$/gi
      @handleImage path, req, res
    else
      @headers res, 404, 'html'
      res.end '404'

  start: ->
    @httpServer = http.createServer (req, res) =>
      path = url.parse(req.url).pathname
      if req.method == "POST"
        @handlePost path, req, res
      else
        @handleGet path, req, res

    @httpServer.listen @port, @host, =>
      console.log "Running at #{@host}:#{@port}"

  stop: ->
    @httpServer?.close()


data = require('./data').all
news = require('./news').all
shopServer = new ShopServer '127.0.0.1', 9999, data, news


shopServer.start()
