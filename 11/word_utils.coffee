
addWord = (text, word) ->
  if text isnt '' then "#{text} #{word}"
  else word

removeWord = (text, remove) ->
  words = text.split /\s/
  (word for word in words when word isnt remove).join ' '

exports.addWord = addWord
exports.removeWord = removeWord