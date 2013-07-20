throw new Error 'Proxy required' unless Proxy?

require 'harmony-reflect'

class Formulaic

  constructor: (@root, @selector, @http, @url) ->
    @source = @root.querySelector @selector
    @handler =
      get: (target, property) ->
        target[property]?.value
      set: (target, property, value) =>
        if @valid property then @sync()
    @fields = new Proxy @source, @handler

  valid: (property) ->
    property isnt ''

  addField: (field, value) ->
    throw new Error "Can't append to DOM" unless @source.appendChild?

    newField = @root.createElement 'input'
    newField.value = value
    @source.appendChild newField

  sync: ->
    throw new Error 'No HTTP specified' unless @http? and @url?

    @http.post @url, JSON.stringify(@source), (response) =>  #B
      for field, fieldResponse of JSON.parse response
        if field of @source
          @source[field].value = fieldResponse.value
        else
          @addField field, fieldResponse.value


  #toJSON: ->
#    JSON.stringify @fields
#    {'a': 'b'}
# inline specs ftw

# how to sync from form back to server?

assert = require 'assert'

obj =
  a:
    value: 'A'
  b:
    value: 'B'

# console.log JSON.stringify(obj)

root =
  createElement: () ->
  querySelector: -> obj

fakeHttp =
  post: (url, json, callback) ->
    otherObj =
      a:
        value: 'changed A'
      b:
        value: 'changed B'
      c:
        value: 'C'

    callback JSON.stringify(otherObj)


f = new Formulaic root, "#a", fakeHttp, 'www.agtron.co'

# assert.equal f.fields.z, 'get'
# f.fields.rr = 2
# assert.equal f.fields.rr, 'get'

# console.log f.fields.a

assert.equal f.fields.a, 'A'

assert.equal f.fields.d, null

f.fields.t = 'k'