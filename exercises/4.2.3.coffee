phonebook =
  numbers:
    hannibal: '555-5551'
    darth: '555-5552'
    hal9000: 'disconnected'
    freddy: '555-5554'
    'T-800': '555-5555'
  list: ->
      "#{name}: #{number}" for name, number of @numbers
  add: (name, number) ->
      if not (name of @numbers)
        @numbers[name] = number
      else
      "#{name} already exists"
  edit: (name, number) ->
      if name of @numbers
        @numbers[name] = number
      else
      "#{name} not found"
  get: (name) ->
      if name of @numbers
        "#{name}: #{@numbers[name]}"
      else
      "#{name} not found"

console.log "Phonebook. Commands are add, get, edit, list, and exit."

process.stdin.setEncoding 'utf8'
stdin = process.openStdin()

stdin.on 'data', (chunk) ->
  args = chunk.split(' ')
  command = args[0].trim()
  name = args[1].trim() if args[1]
  number = args[2].trim() if args[2]
  switch command
    when 'add'
      res = phonebook.add(name, number) if name and number
      console.log res
    when 'get'
      console.log phonebook.get(name) if name
    when 'edit'
      console.log phonebook.edit(name, number) if name and number
    when 'list'
      console.log phonebook.list()
    when 'exit'
      process.exit 1
