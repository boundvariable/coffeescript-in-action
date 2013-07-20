
do ->                 #A
  modules = {}
  cache = {}
  @require = (raw_name) ->      #B
    name = raw_name.replace /[^a-z]/gi, ''
    return cache[name].exports if cache[name]
    if modules[name]
      module = exports: {}
      cache[name] = module
      modules[name]((name) ->
        require name
      , module.exports)
      module.exports
    else throw "No such module #{name}"

  @defmodule = (bundle) ->
    for own key of bundle
      modules[key] = bundle[key]
