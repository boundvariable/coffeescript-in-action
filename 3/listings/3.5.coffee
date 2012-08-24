fs = require 'fs'

split = (text) ->    #A
  text.split /\W/g   #A

count = (text) ->                                               #B
  parts = split text                                            #B
  words = (word for word in parts when word.trim().length > 0)  #B
  words.length                                                  #B

countMany = (texts) ->                          #D
  sum = 0                                       #D
  for text in texts                             #D
    sum = sum + count text                      #D
  sum                                           #D

countWordsInFile = (fileName) ->                            #E
  stream = fs.createReadStream fileName                     #E
  stream.setEncoding 'ascii'                                #E
  wordCount = 0                                             #E
  stream.on 'data', (data) ->                               #E
    lines = data.split /\n/gm                               #E
    wordCount = wordCount + countMany lines                 #E
  stream.on 'close', () ->                                  #E
    console.log "#{wordCount} words"                        #E

file = process.argv[2]      #F

if file                                                    #G
  countWordsInFile file                                    #G
else                                                       #G
  console.log 'usage: coffee 3.5.coffee [file]'            #G
