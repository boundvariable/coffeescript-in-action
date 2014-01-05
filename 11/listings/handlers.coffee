
fs = require 'fs'
url = require 'url'
coffee = require 'coffee-script'

sections = ["11.2", "11.4", "11.5", "11.6", "11.7"]

render = (body, section) ->
  """
  <!DOCTYPE html>
  <html dir='ltr' lang='en-US'>
  <head>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
  <title>The graph!</title>
  <style type='text/css'>
  html, body { margin: 0; padding: 0; }
  </style>
  <script src='/#{section}.js'></script>
  </head>
  <body>
  <div id='status'></div>
  </body>
  </html>
  """

x = 0

increment = (callback) ->
  x = x + 1
  callback()

setInterval ->
  x = Math.floor Math.random()*100
, 1000

ok = (response, type='text/plain') ->
  response.writeHead 200, 'Content-Type': type + '; charset=utf-8'

fail = (response, type='text/plain') ->
  response.writeHead 500, 'Content-Type': type + '; charset=utf8'

js = (request, response) ->
  file = (url.parse(request.url).path.split /\//)[1]
  coffeeFile = file.replace '.js', '.coffee'
  fs.readFile "./#{coffeeFile}", 'utf8', (error, data) ->
    if error
      fail response
      response.end "/* #{error.toString()} */"
    else
      ok response
      response.end (coffee.compile data)

views = (request, response) ->
  query = (url.parse request.url).query
  if query
    params = (url.parse request.url).query.split '&'
    sectionQuery = (params.filter (param) -> /^section=/.test params)[0]
    section = sectionQuery.replace 'section=', ''
    ok response, 'text/html'
    response.end render 'main view', section
  else
    ok response, 'text/html'
    sectionsMarkup = sections.map (section) ->
      "<li><a href='?section=#{section}'>#{section}</a></li>"
    response.end "<ul>#{sectionsMarkup.join ''}</ul>"

incr = (request, response) ->
  complete =  ->
    ok response
    response.end 'incremented to ' + x
  increment complete

callbackName = (s) ->
  result = /callback=([a-z0-9_]+)/gi.exec s
  if result and result.length is 2
    result[1]
  else
    null

feed = (request, response) ->
  {query} = url.parse request.url
  callback = callbackName query
  ok response
  if callback
    response.end """
    #{callback}('{\"hits\":#{x}}');
    """
  else
    response.end "{\"hits\":#{x}}"

exports.incr = incr
exports.views = views
sections.forEach (section) ->
  exports["#{section}.js"] = js
exports['feed.json'] = feed
