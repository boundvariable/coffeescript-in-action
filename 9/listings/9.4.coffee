fs = require 'fs'
{EventEmitter} = require 'events'

withEvents = (emitter, event) ->
  pipeline = []
  data = []

  reset = ->        #A
    pipeline = []   #A

  run = ->                                        #B
    result = data                                 #B
    for processor in pipeline                     #B
      if processor.filter?                        #B
        result = result.filter processor.filter   #B
      else if processor.map?                      #B
        result = result.map processor.map         #B
    result                                        #B

  emitter.on event, (datum) ->   #C
    data.push datum              #C

  filter: (filter) ->                 #D
    pipeline.push {filter: filter}    #D
    @                                 #D
  map: (map) ->                       #D
    pipeline.push {map: map}          #D
    @                                 #D
  evaluate: ->                        #D
    result = run()                    #D
    reset()                           #D
    result                            #D

class CSVRowEmitter extends EventEmitter        #E

  valid = (row) ->
      /[^,]+,[^,]+,[^,]+/.test row

  constructor: (source) ->
    @remainder = ''
    @numbers = []
    stream = fs.createReadStream source, {flags: 'r', encoding: 'utf-8'}
    stream.on 'data', (data) =>
      chunk = data.split /\n/
      firstRow = chunk[0]
      lastRow = chunk[chunk.length-1]
      if not valid firstRow and @remainder
        chunk[0] = @remainder + firstRow
      if not valid lastRow
        @remainder = lastRow
        chunk.pop()
      else @remainder = ''

      @emit('row', row) for row in chunk when valid row


class PhoneBook                                    #F
  asObject = (row) ->
    [name, number, relationship] = row.split ','
    { name, number, relationship }

  asString = (data) ->
    "#{data.name}: #{data.number} (#{data.relationship})"

  print = (s) ->
    s.join '\n'

  relationshipIs = (relationship) ->
    (data) -> data.relationship is relationship

  nameIs = (name) ->
    (data) -> data.name is name

  constructor: (sourceCsv) ->
    csv = new CSVRowEmitter sourceCsv
    @numbers = withEvents(csv, 'row')

  list: (relationship) ->
    evaluated = \
    if relationship
      @numbers                                 #G
      .map(asObject)                           #G
      .filter(relationshipIs relationship)     #G
      .evaluate()                              #G
    else
      @numbers                                 #G
      .map(asObject)                           #G
      .evaluate()                              #G

    print(asString data for data in evaluated)

  get: (name) ->
    evaluated = \
    @numbers                                   #G
    .map(asObject)                             #G
    .filter(nameIs name)                       #G
    .evaluate()                                #G

    print(asString data for data in evaluated)



console.log "Phonebook. Commands are get, list and exit."

process.stdin.setEncoding 'utf8'
stdin = process.openStdin()

phonebook = new PhoneBook 'phone_numbers.csv'

stdin.on 'data', (chunk) ->                           #H
  args = chunk.split ' '                              #H
  command = args[0].trim()                            #H
  name = relationship = args[1].trim() if args[1]     #H
  console.log switch command                          #H
    when 'get'                                        #H
      phonebook.get name                              #H
    when 'list'                                       #H
      phonebook.list relationship                     #H
    when 'exit'                                       #H
      process.exit 1                                  #H
    else 'Unknown command'                            #H
