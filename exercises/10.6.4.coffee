test = (file) ->
  fs.readFile file, 'utf-8', (err, data) ->
    it = """
    {fact, report} = require '../fact'
    assert = require 'assert'
    #{data}
    """
    coffee.run it, filename: file

spec = (file) ->
  if /\#/.test file then false
  else /\.spec\.coffee$/.test file

exports.test = test
exports.spec = spec

# This means that the full file path is passed to both test and spec.
# The tests function should be changed to match:
tests = ->
  fs.readdir SPEC_PATH, (err, files) ->
    for file in files
      test SPEC_PATH + file if spec file
