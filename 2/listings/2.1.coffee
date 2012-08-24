houseRoast = null

hasMilk = (style) ->                  #1
  switch style                        #1
    when "latte", "cappucino"         #1
      yes                             #1
    else                              #1
      no                              #1

makeCoffee = (requestedStyle) ->               #2
  style = requestedStyle || 'Espresso'         #2
  if houseRoast?                               #2
    "#{houseRoast} #{style}"                   #2
  else                                         #2
    style                                      #2

barista = (style) ->                              #3
  time = (new Date()).getHours()                  #3
  if hasMilk(style) and time > 12 then "No!"      #3
  else                                            #3
    coffee = makeCoffee style                     #3
    "Enjoy your #{coffee}!"                       #3


specifyHouseRoast = (roast) ->
  houseRoast = roast

exports.hasMilk = hasMilk
exports.makeCoffee = makeCoffee
exports.barista = barista
exports.specifyHouseRoast = specifyHouseRoast