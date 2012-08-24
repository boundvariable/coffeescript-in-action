fs = require 'fs'

file = process.argv[2]
fs.readFile file, 'utf-8', (error, contents) ->   #A
  if error
    console.log error                             #B
  else
    console.log contents                          #C
