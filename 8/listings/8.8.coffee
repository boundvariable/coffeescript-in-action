
fs = require 'fs'
coffee = require 'coffee-script'

capitalizeFirstLetter = (string) ->
  string.replace /^(.)/, (character) -> character.toUpperCase()

generateTestMethod = (name) ->
  "test#{capitalizeFirstLetter name}: -> assert false"

walkAst = (node) ->
  generated = "assert = require 'assert'"

  if node.body?.classBody
    className = node.variable.base.value
    methodTests = for expression in node.body.expressions
      if expression.base?.properties
        methodTestBodies = for objectProperties in expression.base.properties
          if objectProperties.value.body?
            generateTestMethod objectProperties.variable.base.value
        methodTestBodies.join '\n\n  '
    methodTestsAsText = methodTests.join('').replace /^\n/, ''
    generated += """
      \n
      class Test#{className}
        #{methodTestsAsText}

      test = new Test#{className}
      for methodName of Test#{className}::
        test[methodName]()
    """


  expressions = node.expressions || []
  if expressions.length isnt 0
    for expression in node.expressions
      generated = walkAst expression
  generated

generateTestStubs = (source) ->
  nodes = coffee.nodes source
  walkAst nodes


generateTestFile = (fileName, callback) ->
  fs.readFile fileName, 'utf-8', (err, source) ->
    if err then callback 'No such file'
    testFileName = fileName.replace '.coffee', '_test.coffee'
    generatedTests = generateTestStubs source
    fs.writeFile "#{testFileName}", generatedTests, callback "Generated #{testFileName}"

fileName = process.argv[2]

unless fileName
  console.log 'No file specified'
  process.exit()

generateTestFile fileName, (report) ->
  console.log report