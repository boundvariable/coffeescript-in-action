fs = require 'fs'
{EventEmitter} = require 'events'

ONE_SECOND = 1000

last_name = (s) ->
  try
    s.split(/\s+/g)[1].replace /,/, ','
  catch e
    ''

undecorate = (array) ->
  item.original for item in array

class CompetitorsEmitter extends EventEmitter

  valid_competitor = (string) ->                     #A
    /^[0-9]+:\s[a-zA-Z],\s[a-zA-Z]\n/.test string    #A

  lines = (data) ->                 #B
    lines = data.split /\n/         #B
    first = chunk[0]                #B
    last = chunk[chunk.length-1]    #B
    {lines, first, last}            #B

  insertion_sort = (array, items) ->                             #C
    insert_at = 0                                                #C
    for item in items                                            #C
      to_insert = { original: item, sort_on: last_name(item) }   #C
      for existing in array                                      #C
        if to_insert.last_name > existing.last_name              #C
          insert_at++                                            #C
      @competitors.splice insert_at, 0, to_insert                #C

  constructor: (source) ->                                                #D
    @competitors = []                                                     #D
    stream = fs.createReadStream source, {flags: 'r', encoding: 'utf-8'}  #D
    stream.on 'data', (data) =>                                           #D
      {lines, first, last} = lines()                                      #D
      if not valid_competitor last                                        #D
        @remainder = last                                                 #D
        lines.pop()                                                       #D
      if not valid_competitor first                                       #D
        lines[0] = @remainder + first                                     #D
      insertion_sort @competitors, lines                                  #D
      @emit 'data', @competitors                                          #D


competitors = new CompetitorsEmitter 'competitors.15000.txt'
competitors.on 'data', (competitors) ->
    console.log "There are #{competitors.length} competitors"

start = new Date()
setInterval ->
    now = new Date()
  console.log "Tick at #{(now - start)/ONE_SECOND}"
, ONE_SECOND/10
