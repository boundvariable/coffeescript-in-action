fs = require 'fs'
{EventEmitter} = require 'events'

ONE_SECOND = 1000

lastName = (s) ->
  try
    s.split(/\s+/g)[1].replace /,/, ','
  catch e
    ''

undecorate = (array) ->
  item.original for item in array

class CompetitorsEmitter extends EventEmitter

  validCompetitor = (string) ->                      #A
    /^[0-9]+:\s[a-zA-Z],\s[a-zA-Z]\n/.test string    #A

  lines = (data) ->                 #B
    lines = data.split /\n/         #B
    first = chunk[0]                #B
    last = chunk[chunk.length-1]    #B
    {lines, first, last}            #B

  insertionSort = (array, items) ->                              #C
    insertAt = 0                                                 #C
    for item in items                                            #C
      toInsert = original: item, sortOn: lastName(item)          #C
      for existing in array                                      #C
        if toInsert.lastName > existing.lastName                 #C
          insertAt++                                             #C
      @competitors.splice insertAt, 0, toInsert                  #C

  constructor: (source) ->                                                #D
    @competitors = []                                                     #D
    stream = fs.createReadStream source, {flags: 'r', encoding: 'utf-8'}  #D
    stream.on 'data', (data) =>                                           #D
      {lines, first, last} = lines()                                      #D
      if not validCompetitor last                                         #D
        @remainder = last                                                 #D
        lines.pop()                                                       #D
      if not validCompetitor first                                        #D
        lines[0] = @remainder + first                                     #D
      insertionSort @competitors, lines                                   #D
      @emit 'data', @competitors                                          #D


competitors = new CompetitorsEmitter 'competitors.15000.txt'
competitors.on 'data', (competitors) ->
    console.log "There are #{competitors.length} competitors"

start = new Date()
setInterval ->
    now = new Date()
  console.log "Tick at #{(now - start)/ONE_SECOND}"
, ONE_SECOND/10
