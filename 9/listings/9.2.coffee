decorate_sort_undecorate = (array, sort_rule) ->
    decorate = (array) ->      #1
    {original: item, sort_on: sort_rule item} for item in array

  undecorate = (array) ->                 #2
    item.original for item in array       #2

  comparator = (left,right) ->          #3
    if left.sort_on > right.sort_on     #3
        1                                 #3
      else                                #3
      -1                                #3

  decorated = decorate array             #4
  sorted = decorated.sort comparator     #5
  undecorate sorted                      #6