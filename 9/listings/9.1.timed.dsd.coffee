fs = require 'fs'
http = require 'http'

read_file = (file, strategy) ->
  fs.readFile file, 'utf-8', (error, response) ->
    throw error if error
    strategy response

read_file_as_array = (file, delimiter, callback) -> 
  as_array = (data) ->                              
    callback data.split(delimiter).slice(0,-1)       
  read_file(file, as_array)                         

last_name = (s) ->                          
  s.split(/\s+/g)[1].replace /,/, ','                                  

decorate_sort_undecorate = (array, sort_rule) ->
  decorate = (array) -> 
    {original: item, sort_on: sort_rule item} for item in array

  undecorate = (array) ->                
    item.original for item in array      

  comparator = (left, right) ->         
    if left.sort_on > right.sort_on    
      1                                
    else                                
      -1                                

  decorated = decorate array
  sorted = decorated.sort comparator
  undecorate sorted                     


sorted_competitors_from_file = (file_name, callback) ->  
  newline = /\n/gi                                       
  read_file_as_array file_name, newline, (array) ->      
    callback decorate_sort_undecorate(array, last_name)            

make_server = ->                                           
  response_data = ''                                       
  server = http.createServer (request, response) ->       
    response.writeHead 200, 'Content-Type': 'text/html'     
    response.end JSON.stringify response_data               
  server.listen 8888, '127.0.0.1'                           
  (data) ->                                                 
    response_data = data                                    

main = (file_name) ->
  server = make_server()

  load_data = ->
    start = new Date()
    console.log 'Loading data'
    sorted_competitors_from_file file_name, (data) ->
      elapsed = new Date() - start
      console.log "Data loaded in #{elapsed/1000} seconds"
      server data                                        


  load_data()                                            #E

  fs.watchFile file_name, load_data                      #E


start = new Date()
setInterval ->
  console.log "Clock tick at #{(new Date()-start)/1000} seconds"
, 1000


if process.argv[2]                                  #F
  main process.argv[2]                              #F
  console.log "Starting server on port 8888"        #F
else                                                #F
  console.log "usage: coffee 9.1.coffee [file]"     #F

