views = {}                                    #1

viewsIncrement = (key) ->                     #2
  views[key] ?= 0                             #2
  views[key] = views[key] + 1                 #2

total = ->
  sum = 0                                      #3
  for own url, count of views                  #3
    sum = sum + count                          #3
  sum

exports.views = views
exports.viewsIncrement = viewsIncrement
exports.total = total