
assert = require 'assert'

{addWord, removeWord} = require './word_utils'    #A

fact = (description, fn) ->                       #B
  try                                             #B
    fn()                                          #B
    console.log "#{description}: OK"              #B
  catch e                                         #B
    console.error "#{description}: "              #B
    throw e                                       #B


fact "addWord adds a word", ->
  input = "product special"
  expectedOutput = "product special popular"
  actualOutput = addWord input, "popular"

  assert.equal expectedOutput, actualOutput

fact "removeWord removes a word and surrounding whitespace", ->
  tests = [
    initial: "product special"
    replace: "special"
    expected: "product"
  ,
    initial: "product special"
    replace: "spec"
    expected: "product special"
  ]

  for {initial, replace, expected} in tests
    assert.equal removeWord(initial, replace), expected
