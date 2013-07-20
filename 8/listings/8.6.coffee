
fs = require 'fs'
coffee = require 'coffee-script'

evalScruffyCoffeeFile = (fileName) ->
  fs.readFile fileName, 'utf-8', (err, scruffyCode) ->
    coffeeCode = scruffyCode.replace /λ([a-zA-Z]+).([a-zA-Z]+)/g, '($1) -> $2'
    coffee.eval coffeeCode

fileName = process.argv[2]
process.exit 'No file specified' unless fileName
evalScruffyCoffeeFile fileName
