houseRoast = null

hasMilk = (style) ->
  switch style.toLowerCase()
    when "latte", "cappucino"
      yes
    else
      no

makeCoffee = (requestedStyle) ->
  style = requestedStyle || 'Espresso'
  console.log houseRoast
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


###
Browser Scripting
###

order = document.querySelector '#order'
request = document.querySelector '#request'
response = document.querySelector '#response'

order.onsubmit = ->
  alert barista(request.value)
  response.innerHTML = barista(request.value)
  false
