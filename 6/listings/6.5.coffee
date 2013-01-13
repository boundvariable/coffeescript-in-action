http = require 'http'
url = require 'url'

{products, users} = require './db'

withCompleteBody = (req, callback) ->
  body = ''
  req.on 'data', (chunk) ->
    body += chunk.toString()
    request.on 'end', -> callback()

paramsAsObject = (params) ->
  pairs = params.split /&/g
  result = {}
  for pair in pairs
    splitPair = pair.split /\=/g
    result[splitPair[0]] = splitPair[1]
  result

header = (response, status, contentType='text/plain;charset=utf-8') ->
  response.writeHead status, 'Content-Type': contentType

httpRequestMatch = (request, method) -> request.method is method
isGet = (request) -> httpRequestMatch request, "GET"
isPost = (request) -> httpRequestMatch request, "POST"

render = (response, content) ->
  header response, 200
  response.end content, 'utf8'

renderAsJson = (response, object) -> render response, JSON.stringify object

notFound = (response) ->
  header response, 404
  response.end 'not found', 'utf8'

handleProfitRequest = (request, response, price) ->
  valid = (price) -> price and /^[0-9]+$/gi.test price
  if valid price
    renderAsJson response, profit: profit price
  else
    renderAsJson response, profit: 0

makeDbOperator = (db) ->
  (operation) ->
    (entry, params...) ->
      db[operation] entry, params...

makeRequestHandler = (load, save) ->
  rendersIfFound = (response) ->
    (error, data) ->
      if error
        notFound()
      else
        renderAsJson response, data

  (request, response, name) ->
    if isGet request
      load name, rendersIfFound response
    else if isPost request
      withCompleteBody request, ->
        save name, rendersIfFound response
    else
      notFound()

numberSold = (salePrice) ->
  50 + 20/10 * (200 - salePrice)

profit = (numberSold, costPrice, overhead) ->
  revenue = (salePrice) ->
    (numberSold salePrice) * salePrice
  cost = (salePrice) ->
    overhead + (numberSold salePrice) * costPrice

  (revenue salePrice) - (cost salePrice)

loadProductData = (makeDbOperator products) 'get'
saveProductData = (makeDbOperator products) 'set'
loadUserData = (makeDbOperator users) 'get'
saveUserData = (makeDbOperator users) 'set'

handleUserRequest = makeRequestHandler loadUserData, saveUserData
handleProductRequest = makeRequestHandler loadProductData, saveProductData

apiServer = (request, response) ->
  path = url.parse(request.url).path
  parts = path.split /\//
  switch parts[1]
    when 'profit'
      handleProfitRequest request, response, parts[2]
    when 'user'
      handleUserRequest request, response, parts[2]
    when 'product'
      handleProductRequest request, response, parts[2]
    else
      notFound response

server = http.createServer(apiServer).listen 8080, '127.0.0.1'

exports.server = server
