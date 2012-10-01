class Views                                        #1
  constructor: ->                                  #2
    @pages = {}                                    #2
  increment: (key) ->                              #3
    @pages[key] ?= 0                               #3
    @pages[key] = @pages[key] + 1                  #3
  total: () ->                                     #4
    sum = 0                                        #4
    for own url, count of @pages                   #4
      sum = sum + count                            #4
    sum                                            #4

businessViews = new Views                         #5
personalViews = new Views                         #5

exports.Views = Views