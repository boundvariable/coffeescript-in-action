stock = 30                                                           #A
server = http.createServer (req, res) ->                             #A
  response = switch req.url                                          #A
    when 'purchase'                                                  #A
      res.writeHead 200, 'Content-Type': 'text/plain;charset=utf8'   #A
      if stock > 0                                                   #A
        stock = stock – 1                                            #A
        'you just purchased one!'                                    #A
      else                                                           #A
        'sorry! no stock left!'                                      #A
    else                                                             #A
      res.writeHead 404, 'Content-Type': 'text/plain;charset=utf8'   #A
      'what do you want to do?'                                      #A
  res.end response                                                   #A



purchase = (callback) ->                                             #B
  db.decrement 'stock', (error, response) ->                         #B
    if error                                                         #B
      callback 0                                                     #B
    else                                                             #B
      callback response                                              #B

server = http.createServer (req, res) ->                             #B
  render = (stock) ->                                                #B
    res.writeHead 200, 'Content-Type': 'text/plain;charset=utf8'     #B
    if stock > 0                                                     #B
      res.end 'you just purchased one!'                              #B
    else                                                             #B
      'sorry! no stock left'                                         #B

  switch req.url                                                     #B
    when 'purchase'                                                  #B
      purchase render                                                #B
    else                                                             #B
      res.writeHead 404, 'Content-Type': 'text/plain;charset=utf8'   #B
      res.end 'not found!'                                           #B

#A Your program keeping state
#B The database keeping state
