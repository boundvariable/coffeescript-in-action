people = [ 'bill', 'ted' ]
greetings = {}

for person in people
  greetings[person] = ->
    "My name is #{person}"

greetings.bill()
# My name is ted
