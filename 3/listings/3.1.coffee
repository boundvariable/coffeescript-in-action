text = process.argv[2]        #A

if text                                       #B
  words = text.split /,/                      #B
  console.log "#{words.length} partygoers"    #B
else                                                      #C
  console.log 'usage: coffee 3.1.coffee [text]'           #C
