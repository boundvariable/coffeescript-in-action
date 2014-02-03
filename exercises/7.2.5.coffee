assert = require 'assert'

# Given an array of numbers such as [1,2,3,4,5,6],
# write a function that uses destructuring and a comprehension
# to reverse each subsequent pair of numbers in the array so that,
# for example, [1,2,3,4,5] becomes [2,1,4,3,6,5] and
# [1,2,1,2,1,2] becomes [2,1,2,1,2,1].

swapPairs = (array) ->
  for index in array by 2
    [first, second] = array[index-1..index]
    [second, first]

# Almost!
swapPairs([3,4,3,4,3,4])
# [ [ 4, 3 ], [ 4, 3 ], [ 4, 3 ] ]

swapPairs([1,2,3,4,5,6])
# [ [ 2, 1 ], [ 4, 3 ], [ 6, 5 ] ]

swapPairs = (array) ->
  reversedPairs = for index in array by 2
    [first, second] = array[index-1..index]
    [second, first]
  [].concat reversedPairs...

swapPairs([3,4,3,4,3,4])
# [ 4, 3, 4, 3, 4, 3 ]

swapPairs([1,2,3,4,5,6])
# [ 2, 1, 4, 3, 6, 5 ]

assert.deepEqual swapPairs([1,2,3,4,5,6]), [2,1,4,3,6,5]
assert.deepEqual swapPairs([1,2,1,2,1,2]), [2,1,2,1,2,1]

# Suppose you have received some JSON representing a phone directory

phoneDirectory = {
  "A": [
    {"name": "Fred", "phone": "555 1111"},
    {"name": "Bill", "phone": "555 1112"}
  ]
  "B": [
    {"name": "Sam", "phone": "555 1113"}
  ]
}

# Equivalent to this Coffeescript

phoneDirectory =
  A: [
      name: 'Abe'
      phone: '555 1110'
    ,
      name: 'Andy'
      phone: '555 1111'
    ,
      name: 'Alice'
      phone: '555 1112'
  ]
  B: [
      name: 'Bam'
      phone: '555 1113'
  ]

# Write a function that produces the last phone number for a given letter found in the phone directory.

lastNumberForLetter = (letter, directory) ->
  [..., lastForLetter] = directory[letter]
  {phone} = lastForLetter
  phone


assert.equal lastNumberForLetter('A', phoneDirectory), '555 1112'
assert.equal lastNumberForLetter('B', phoneDirectory), '555 1113'
