
http = require 'http'
fs = require 'fs'
coffee = require 'coffee-script'

render = (res, head, body) ->
  res.writeHead 200, 'Content-Type': 'text/html'
  res.end """
    <!doctype html>
    <html lang=en>
      <head>
        <meta charset=utf-8>
        <title>Chapter 7</title>
        <style type='text/css'>
        * { font-family: helvetica, arial, sans-serif; }
        body { font-size: 120%; }
        .teams td { padding: 5px; }
        </style>
        #{head}
      </head>
      <body>
        #{body}
      </body>
    </html>
  """

listing = (id) ->
  markup =
    1: """
       <ul class='teams'>
       </ul>"""
    2: """
       <ul class='teams'>
       </ul>"""
    3: """
       <table class='teams'>
         <thead>
           <tr>
             <th>Team</th><th>Points</th><th>Scored</th><th>Conceded</th>
           <tr>
         </thead>
       </table>"""
    4: """
       <table class='teams'>
         <thead>
           <tr>
             <th>Team</th><th>Points</th><th>Scored</th><th>Conceded</th>
           <tr>
         </thead>
       </table>"""
  script =
    1: "<script src='1.js'></script>"
    2: "<script src='2.js'></script>"
    3: "<script src='3.js'></script>"
    4: "<script src='4.js'></script>"

  head: script[id], body: markup[id]

routes = {}

for n in [1..6]
  do ->
    listingNumber = n
    routes["/#{listingNumber}"] = (res) ->
      render res, listing(listingNumber).head, listing(listingNumber).body
    routes["/#{listingNumber}.js"] = (res) ->
      script res, listingNumber


server = http.createServer (req, res) ->
  handler = routes[req.url] or (res) ->
    render res, '', '''
      <ul>
        <li><a href="/1">Listing 7.1</a></li>
        <li><a href="/2">Listing 7.2</a></li>
        <li><a href="/3">Listing 7.3</a></li>
        <li><a href="/4">Listing 7.4</a></li>
      </ul>
    '''
  handler res

script = (res, listing) ->
  res.writeHead 200, 'Content-Type': 'application/javascript'
  fs.readFile "7.#{listing}.coffee", 'utf-8', (e, source) ->
    if e then res.end "/* #{e} */"
    else res.end coffee.compile source


server.listen 8080, '127.0.0.1'
