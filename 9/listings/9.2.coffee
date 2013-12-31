decorateSortUndecorate = (array, sortRule) ->
  decorate = (array) ->                                         #A
    {original: item, sortOn: sortRule item} for item in array   #A

  undecorate = (array) ->                 #2
    item.original for item in array       #2

  comparator = (left, right) ->         #3
    if left.sortOn > right.sortOn       #3
      1                                 #3
    else                                #3
      -1                                #3

  decorated = decorate array             #4
  sorted = decorated.sort comparator     #5
  undecorate sorted                      #6

assert = require 'assert'
