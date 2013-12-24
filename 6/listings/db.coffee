fs = require 'fs'

## This Db only persists to disk once
## per minute. You probably don't want
## to use it for important data
oneMinute = -> 60000

class Db
  noop = (args..., callback) ->
    callback new Error 'Sync'

  constructor: (file) ->
    set = (key, value, callback) =>
      if !key
        callback? new Error 'No key'
      else
        @data[key] = value
        callback? null, @data[key]

    get = (key, callback) =>
      if !key
        @all callback
      else if @data[key]
        callback null, @data[key]
      else
        callback new Error 'Not found'

    decr = (key, callback) ->
      num = parseInt @data[key], 10
      if !(isNaN num)
        num = num - 1
        @set key, num
        callback null, num
      else
        callback new Error 'Failed to decrement'

    all = (callback) =>
      callback null, @data

    exit = (callback) =>
      @sync()
      clearTimeout @syncTimeout

    @ready = =>
      @get = get
      @set = set
      @decr = decr
      @all = all
      @exit = exit
      @onreadyCallback?()
      @onreadyCallback = null

    @onready = (callback) ->
      @onreadyCallback = callback

    @suspended = =>
      @get = noop
      @set = noop
      @decr = noop
      @all = noop
      @exit = noop

    @sync = (callback) =>
      @suspended()
      console.log "About to write file #{file}"
      fs.writeFile file, (JSON.stringify @data), =>
        console.log "Wrote #{JSON.stringify(@data)}"
        callback?()
        @ready()

    fs.readFile file, 'utf8', (error, data) =>
      console.log "Read file #{file}"
      @data = (JSON.parse data) || Object.create null
      console.log "Read #{JSON.stringify(@data)}"
      @syncTimeout = setTimeout @sync, oneMinute()
      @ready()


users = new Db './users.json'
products = new Db './products.json'
stock = new Db './stock.json'

exports.Db = Db
exports.users = users
exports.products = products
exports.stock = stock