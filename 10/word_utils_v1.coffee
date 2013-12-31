removeWord = (text, word) ->
  replaced = text.replace word, ''    #A
  replaced.replace(/^\s\s*/, '').replace(/\s\s*$/, '')  #B

addWord = (text, word) ->
    "#{text} #{word}"

exports.addWord = addWord
exports.removeWord = removeWord
