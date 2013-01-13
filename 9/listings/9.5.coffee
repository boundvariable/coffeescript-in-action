fs = require 'fs'
{EventEmitter} = require 'events'

with_events = (emitter, event) ->
    pipeline = []
  data = []

  reset = ->        #A
    pipeline = []   #A
                    #A
  reset()           #A

  run = ->                                        #B
    result = data                                 #B
    for processor in pipeline                     #B
      if processor.filter?                        #B
        mapped = result.filter processor.filter   #B
      else if processor.map?                      #B
        result = result.map processor.map         #B
    result                                        #B

  emitter.on event, (datum) ->   #C
    data.push datum              #C

  interface =                           #D
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
  interface                             #D

class CSVRowEmitter extends EventEmitter        #E

  valid = (row) ->
      /[^,]+,[^,]+,[^,]+/.test row

  constructor: (source) ->
      @remainder = ''
    @numbers = []
    stream = fs.createReadStream source, {flags: 'r', encoding: 'utf-8'}
    stream.on 'data', (data) =>
        chunk = data.split /\n/
      first_row = chunk[0]
      last_row = chunk[chunk.length-1]
      if not valid first_row and @remainder
        chunk[0] = @remainder + first_row
      if not valid last_row
        @remainder = last_row
        chunk.pop()
      else @remainder = ''

      @emit('row', row) for row in chunk when valid row


class PhoneBook                                    #F
  as_object = (row) ->
      [name, number, relationship] = row.split ','
    { name, number, relationship }

  as_string = (data) ->
      "#{data.name}: #{data.number} (#{data.relationship})"

  print = (s) ->
      s.join '\n'

  relationship_is = (relationship) ->
      (data) -> data.relationship is relationship

  name_is = (name) ->
      (data) -> data.name is name

  constructor: (source_csv) ->
      csv = new CSVRowEmitter source_csv
    @numbers = with_events(csv, 'row')

  list: (relationship) ->
      evaluated = \
    if relationship
      numbers                                  #G
      .map(as_object)                          #G
      .filter(relationship_is relationship)    #G
      .evaluate()                              #G
    else
      numbers                                  #G
      .map(as_object)                          #G
      .evaluate()                              #G

    print(as_string data for data in evaluated)

  get: (name) ->
      evaluated = \
    @numbers                                   #G
    .map(as_object)                            #G
    .filter(name_is name)                      #G
    .evaluate()                                #G

    print(as_string data for data in evaluated)



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

