
# let with a rewriter

fs = require 'fs'
coffee = require 'coffee-script'

evalScruffyCoffeeFile = (fileName) ->
  fs.readFile fileName, 'utf-8', (error, scruffyCode) ->
    letReplacedScruffyCode = scruffyCode.replace /\slet\s/g, ' $LET '
    return if error
    tokens = coffee.tokens letReplacedScruffyCode

    i = 0
    consumingLet = false
    waitingForOutdent = 0
    while token = tokens[i]
      if token[0] is 'IDENTIFIER' and token[1] is '$LET'
        consumingLet = true
        doToken = ['UNARY', 'do', spaced: true]
        tokens.splice i, 1, doToken
      else if consumingLet
        if token[0] is 'CALL_START'
          paramStartToken = ['PARAM_START', '(', spaced: true]
          tokens[i + 1][2] = 0
          tokens.splice i, 1, paramStartToken
        if token[0] is 'CALL_END'
          paramEndToken = ['PARAM_END', ')', spaced: true]
          functionArrowToken = ['->', '->', spaced: true]
          indentToken = ['INDENT', 2, generated: true]
          tokens.splice i, 2, paramEndToken, functionArrowToken, indentToken
          consumingLet = false
          waitingForOutdent++
      else if waitingForOutdent isnt 0
        if token[0] is 'OUTDENT'
          outdentToken = ['OUTDENT', 2, generated: true]
          tokens.splice i, 0, outdentToken
          waitingForOutdent--
      i++

    nodes = coffee.nodes tokens

    javaScript = nodes.compile()
    console.log javaScript
    eval javaScript

fileName = process.argv[2]
process.exit 'No file specified' unless fileName
evalScruffyCoffeeFile fileName
