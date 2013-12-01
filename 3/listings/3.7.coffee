fs = require 'fs'
http = require 'http'
coffee = require 'coffee-script'   #1

attendees = 0         #2
friends = 0           #2

split = (text) ->
  text.split /,/g

accumulate = (initial, numbers, accumulator) ->
  total = initial or 0
  for number in numbers
    total = accumulator total, number
  total

sum = (accum, current) -> accum + current

attendeesCounter = (data) ->             #3
  attendees = data.split(/,/).length     #3

friendsCounter = (data) ->                                     #4
  numbers = (parseInt(string, 0) for string in split data)     #4
  friends = accumulate(0, numbers, sum)                        #4

readFile = (file, strategy) ->                        #5
  fs.readFile file, 'utf-8', (error, response) ->     #5
    throw error if error                              #5
    strategy response                                 #5

countUsingFile = (file, strategy) ->                        #6
  readFile file, strategy                                   #6
  fs.watch file, (-> readFile file, strategy)               #6

init = ->
  countUsingFile 'partygoers.txt', attendeesCounter    #7
  countUsingFile 'friends.txt', friendsCounter         #7

  server = http.createServer (request, response) ->                   #8
    switch request.url                                                #8
      when '/'                                                        #8
        response.writeHead 200, 'Content-Type': 'text/html'           #8
        response.end view                                             #8
      when '/count'                                                   #8
        response.writeHead 200, 'Content-Type': 'text/plain'          #8
        response.end "#{attendees + friends}"                         #8

  server.listen 8080, '127.0.0.1'        #9
  console.log 'Now running at http://127.0.0.1:8080'

  #10
  clientScript = coffee.compile '''
  get = (path, callback) ->
    req = new XMLHttpRequest()
    req.onload = (e) -> callback req.responseText
    req.open 'get', path
    req.send()

  showAttendees = ->
    out = document.querySelector '#how-many-attendees'
    get '/count', (response) ->
      out.innerHTML = "#{response} attendees!"

  showAttendees()
  setInterval showAttendees, 1000
  '''

  #11
  view = """
  <!doctype html>
  <title>How many people are coming?</title>
  <body>
  <div id='how-many-attendees'></div>
  <script>
  #{clientScript}
  </script>
  </body>
  </html>
  """

init()

###
exports.attendeesCounter = attendeesCounter
exports.friendsCounter = friendsCounter
exports.readFile = readFile
exports.countUsingFile = countUsingFile
###
