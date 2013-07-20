fs = require 'fs'
coffee = require 'coffee-script'

evalScruffyCoffeeFile = (fileName) ->
  fs.readFile fileName, 'utf-8', (error, scruffyCode) ->
    return if error
    tokens = coffee.tokens scruffyCode

    i = 0
    while token = tokens[i]
      isLambda = token[0] is 'IDENTIFIER' and /^λ[a-zA-Z]+$/.test token[1]
      if isLambda and tokens[i + 1][0] is '.'
        paramStart = ['PARAM_START', '(', {}]
        param = ['IDENTIFIER', token[1].replace(/λ/, ''), {}]
        paramEnd =  ['PARAM_END', ')', {}]
        arrow = ['->', '->', {}]
        indent = ['INDENT', 2, generated: true]
        tokens.splice i, 2, paramStart, param, paramEnd, arrow, indent
        j = i
        while tokens[j][0] isnt 'TERMINATOR'
          j++
        outdent = ['OUTDENT', 2, generated: true]
        tokens.splice j, 0, outdent
        i = i + 3
        continue
      i++

    nodes = coffee.nodes tokens
    javaScript = nodes.compile()
    eval javaScript

fileName = process.argv[2]
unless fileName
  console.log 'No file specified'
  process.exit()

evalScruffyCoffeeFile fileName
