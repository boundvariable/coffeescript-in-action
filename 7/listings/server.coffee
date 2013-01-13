
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
    listing_number = n
    routes["/#{listing_number}"] = (res) ->
      render res, listing(listing_number).head, listing(listing_number).body
    routes["/#{listing_number}.js"] = (res) ->
      script res, listing_number


server = http.createServer (req, res) ->
  handler = routes[req.url] or (res) -> res.end 'nothing here'
  handler res

script = (res, listing) ->
  res.writeHead 200, 'Content-Type': 'application/javascript'
  fs.readFile "7.#{listing}.coffee", 'utf-8', (e, source) ->
    if e then res.end "/* #{e} */"
    else res.end coffee.compile source


server.listen 8080, '127.0.0.1'
