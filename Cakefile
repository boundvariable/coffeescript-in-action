
{exec} = require 'child_process'

task 'spec', 'Run chapter snippet specs', ->
  [1..13].forEach (chapter) ->
    exec "coffee #{chapter}/#{chapter}.spec.coffee", (err, data) ->
      if err
        console.error "FAIL chapter #{chapter}"
        console.error err
      else
        console.log data
