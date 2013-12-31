fs = require 'fs'
coffee = require 'coffee-script'

test = (file) ->
  fs.readFile file, 'utf-8', (err, data) ->
    it = """
      {fact, report} = require './fact'
      assert = require 'assert'
      #{data}
      report '#{file}'
    """
    coffee.run it, filename: file    #A

spec = (file) ->
  /[^.]*\.spec\.coffee$/.test file

fs.readdir '.', (err, files) ->      #B
  for file in files                  #B
    test file if spec file           #B
