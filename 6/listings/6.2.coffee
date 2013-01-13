# Important: Do not write like this

http = require 'http'
url = require 'url'

{users, products} = require './db'

server = http.createServer (req, res) ->
  path = url.parse(req.url).path
  parts = path.split /\//
  switch parts[1]
    when 'profit'
      res.writeHead 200, 'Content-Type': 'text/plain;charset=utf-8'
      if parts[2] and /^[0-9]+$/gi.test parts[2]
        price = parts[2]
        profit = (50+(20/10)*(200-price))*                          #A
        price-(140+(100*(50+((20/10)*(200-price)))))                #A
        res.end (JSON.stringify { profit: profit parts[2] })
      else
        res.end JSON.stringify { profit: 0 }
    when 'user'
      res.writeHead 200, 'Content-Type': 'text/plain;charset=utf-8'
      if req.method is "GET"
        if parts[2] and /^[a-z]+$/gi.test parts[2]
          users.get parts[2], (error, user) ->
            res.end JSON.stringify user, 'utf8'
        else
          users.all (error, users) ->
            res.end JSON.stringify users, 'utf8'
      else if parts[2] and req.method is "POST"
        user = parts[2]
        requestBody = ''
        req.on 'data', (chunk) ->
          requestBody += chunk.toString()
        req.on 'end', ->
          pairs = requestBody.split /&/g
          decodedRequestBody = for pair in pairs
            o = {}
            splitPair = pair.split /\=/g
            o[splitPair[0]] = splitPair[1]
            o
          users.set user, decodedRequestBody, ->
            res.end 'success', 'utf8'
      else
        res.writeHead 404, 'Content-Type': 'text/plain;charset=utf-8'
        res.end '404'
    when 'product'
      res.writeHead 200, 'Content-Type': 'text/plain;charset=utf-8'
      if req.method is "GET"
        products.get parts[2], (product) ->
          res.end JSON.stringify product, 'utf8'
      else if parts[2] and req.method is "POST"
        product = parts[2]
        requestBody = ''
        req.on 'data', (chunk) ->
          requestBody += chunk.toString()
        req.on 'end', ->
          pairs = requestBody.split /&/g
          decodedRequestBody = for pair in pairs
            o = {}
            splitPair = pair.split /\=/g
            o[splitPair[0]] = splitPair[1]
            o
          product.set user, decodedRequestBody, ->
            res.end 'success', 'utf8'
        requestBody = ''
        req.on 'data', (chunk) ->
          requestBody += chunk.toString()
        req.on 'end', ->
          decodedRequestBody = requestBody
          res.end decodedRequestBody, 'utf8'
      else
        res.writeHead 404, 'Content-Type': 'text/plain;charset=utf-8'
        res.end '404'
    else
      res.writeHead 200, 'Content-Type': 'text/html;charset=utf-8'
      res.end 'The API'

server.listen 8080, '127.0.0.1'

# Important: Do not write programs like this.
#A Part of the program you already addressed
