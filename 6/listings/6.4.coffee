http = require 'http'
db = (require './db').stock

stock = 30                                                           #A
serverOne = http.createServer (req, res) ->                          #A
  response = switch req.url                                          #A
    when '/purchase'                                                 #A
      res.writeHead 200, 'Content-Type': 'text/plain;charset=utf8'   #A
      if stock > 0                                                   #A
        stock = stock-1                                              #A
        "Purchased! There are #{stock} left."                        #A
      else                                                           #A
        'Sorry! no stock left!'                                      #A
    else                                                             #A
      res.writeHead 404, 'Content-Type': 'text/plain;charset=utf8'   #A
      'Go to /purchase'                                              #A
  res.end response                                                   #A



serverTwo = http.createServer (req, res) ->                          #B
  purchase = (callback) ->                                           #B
    db.decr 'stock', (error, response) ->                            #B
      if error                                                       #B
        callback 0                                                   #B
      else                                                           #B
        callback response                                            #B

  render = (stock) ->                                                #B
    res.writeHead 200, 'Content-Type': 'text/plain;charset=utf8'     #B
    response = if stock > 0                                          #B
      "Purchased! There are #{stock} left."                          #B
    else                                                             #B
      'Sorry! no stock left'                                         #B
    res.end response                                                 #B

  switch req.url                                                     #B
    when '/purchase'                                                 #B
      purchase render                                                #B
    else                                                             #B
      res.writeHead 404, 'Content-Type': 'text/plain;charset=utf8'   #B
      res.end 'Go to /purchase'                                      #B

serverOne.listen 9091, '127.0.0.1'
serverTwo.listen 9092, '127.0.0.1'

#A Your program keeping state
#B The database keeping state
