fs = require 'fs'

houseRoast = null

hasMilk = (style) ->
  switch style.toLowerCase()
    when "latte", "cappucino"
      yes
    else
      no

makeCoffee = (requestedStyle) ->
  style = requestedStyle || 'Espresso'
  if houseRoast?
    "#{houseRoast} #{style}"
  else
    style

barista = (style) ->
  time = (new Date()).getHours()
  if hasMilk(style) and time > 12 then "No!"
  else
    coffee = makeCoffee style
    "Enjoy your #{coffee}!"

main = ->
  requestedCoffee = process.argv[2]
  if !requestedCoffee?
    console.log 'You need to specify an order'
  else
    fs.readFile 'house_roast.txt', 'utf-8', (err, data) ->
      if data then houseRoast = data.replace /\n/, ''
      console.log barista(requestedCoffee)

main()