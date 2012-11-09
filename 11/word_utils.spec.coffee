assert = require 'assert'

{addWord, removeWord} = require './word_utils'

fact = (description, fn) ->
  try
    fn()
    console.log "#{description}: OK"
  catch e
    console.log "#{description}: \n#{e.stack}"

fact "addWord adds a word", ->
  input = "ultra mega"
  expectedOutput = "ultra mega ok"
  actualOutput = addWord input, "ok"

  assert.equal expectedOutput, actualOutput

fact "remove_word removes a word and surrounding whitespace", ->
  tests = [
    initial: "ultra mega"
    replace: "mega"
    expected: "ultra"
  ,
    initial: "ultra mega"
    replace: "meg"
    expected: "ultra mega"
  ]

  for test in tests
    assert.equal removeWord(test.initial, test.replace), test.expected

