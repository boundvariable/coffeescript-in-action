views =
  excluded: []
  pages: {}
  clear: ->
    @pages = {}
  increment: (key) ->
   unless key in @excluded
     @pages[key] ?= 0
     @pages[key] = @pages[key] + 1
  ignore: (page) ->
      @excluded = @excluded.concat page
  total: ->
    sum = 0
    for own page, count of @pages
      sum = sum + count
    sum

views.excluded.push '/x'

views.increment '/y'
views.increment '/y'
views.increment '/a'

views.increment '/x'
views.increment '/x'
views.increment '/x'
views.increment '/x'

views.total()
# 3