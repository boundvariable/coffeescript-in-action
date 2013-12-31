assert = require 'assert'
{addWord, removeWord} = require './word_utils_v1'

do removeWordShouldRemoveOneWord = ->
  tests = [                          #A
    initial: "product special"       #A
    replace: "special"               #A
    expected: "product"              #A
  ,                                  #A
    initial: "product special"       #A
    replace: "spec"                  #A
    expected: "product special"      #A
  ]

  for test in tests                                      #B
    actual = removeWord(test.initial, test.replace)      #B
    assert.equal actual, test.expected                   #B


do addWordShouldAddOneWord = ->
  try                                              #A
    input = "product special"                      #A
    expectedOutput = "product"                     #A
    actualOutput = addWord input, "ok"             #A
    assert.equal expectedOutput, actualOutput      #A
    console.log 'addWord passed'                   #A
  catch                                            #A
    console.log 'addWord failed'
