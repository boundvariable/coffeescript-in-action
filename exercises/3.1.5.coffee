# Write a version of countWords that ignores words shorter than three letters.

countWords = (text) ->
  words = text.split /[\s,]+/                              # match on space or comma
  (word for word in words when word.length > 3).length     # evaluate to the length of the comprehension result

console.log countWords 'There are nine words longer than three letters in this sentence.'
# 9

###
Write a function that creates a new space-delimited string of words containing only
every second word in the original space-delimited string. For example,
###
everyOtherWord = (text) ->
  words = text.split /[\s,]+/
  takeOther = for word, index in words
    if index % 2 then ''
    else word
  takeOther.join(' ').replace /\s\s/gi, ' '

misquote = """we like only like think like when like we like are like confronted like with like a like problem"""
# 'we only think when we are confronted with a problem'

everyOtherWord 'first second third fourth fifth sixth seventh eighth ninth tenth'
# first third fifth seventh ninth
