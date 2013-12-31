{example} = require './src/example'

fact 'example', ->
  assert.equal 'x', 'x'
  assert.equal example(), '123'