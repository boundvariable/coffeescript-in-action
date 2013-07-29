phonebook =
  numbers:                      #A
    hannibal: '555-5551'        #A
    darth: '555-5552'           #A
    hal9000: 'disconnected'     #A
    freddy: '555-5554'          #A
    'T-800': '555-5555'         #A
  list: ->                                                          #B
    "#{name}: #{number}" for name, number of @numbers               #B
  add: (name, number) ->                                            #B
    if not (name of @numbers)                                       #B
      @numbers[name] = number                                       #B
  get: (name) ->                                                    #B
    if name of @numbers                                             #B
      "#{name}: #{@numbers[name]}"                                  #B
    else                                                            #B
      "#{name} not found"                                           #B


### uncomment this to run from command line
console.log "Phonebook. Commands are add get list and exit."

process.stdin.setEncoding 'utf8'    #C
stdin = process.openStdin()         #C

stdin.on 'data', (chunk) ->              #D
  args = chunk.split(' ')
  command = args[0].trim()               #E
  name = args[1].trim() if args[1]       #E
  number = args[2].trim() if args[2]     #E
  switch command                                             #F
    when 'add'                                               #F
      res = phonebook.add(name, number) if name and number   #F
      console.log res                                        #F
    when 'get'                                               #F
      console.log phonebook.get(name) if name                #F
    when 'list'                                              #F
      console.log phonebook.list()
    when 'exit'
      process.exit 1
###

exports.phonebook = phonebook