
do add_word_should_add_one_word = ->
  input = "ultra mega"
  expected_output = "ultra mega ok"
  actual_output = add_word input, "ok"

  assert.equal expected_output, actual_output

