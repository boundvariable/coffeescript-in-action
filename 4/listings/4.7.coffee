views =
  clear: ->
    @pages = {}                                     #A
  increment: (key) ->
    @pages ?= {}
    @pages[key] ?= 0
    @pages[key] = @pages[key] + 1
  total: ->
    sum = 0
    for own page, count of @pages
      sum = sum + count
    sum

exports.businessViews = Object.create views
exports.personalViews = Object.create views