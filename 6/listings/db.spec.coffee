{describe, it} = require 'chromic'
fs = require 'fs'

{Db} = require './db'

describe 'db', ->
  fs.writeFile = (_, __, cb) -> cb()
  fs.readFile = (_, __, cb) ->
    raw = '''
    {
      "bob": {
        "x": 1,
        "y": 2
      }
    }
    '''
    cb null, raw

  users = new Db './users.json'

  it 'gets', ->
    users.get 'bob', (error, data) ->
      data.shouldBe {"x": 1, "y": 2}

  it 'sets', ->
    users.set 'bob', 11, ->
      users.get 'bob', (error, data) ->
        data.shouldBe 11

  it 'suspends on write', ->
    fs.writeFile = (_, __, cb) ->
      setTimeout cb, 1000
    users.sync()
    users.get 'anything', (error, data) ->
      error.message.shouldBe 'Sync'