hasMilk = (style) ->
  switch style
    when "latte", "cappucino"
      yes
    else
      no

makeCoffee = ->
  style || 'Espresso'


barista = (style) ->                #2
  now = new Date()                  #3
  time = now.getHours()             #3
  if hasMilk(style) and time > 12   #3
    "No!"                           #4
  else                              #3
    coffee = makeCoffee style       #5
    "Enjoy your #{coffee}!"         #5




barista "latte"

### JavaScript (see also 2.2.clean.js)

var hasMilk = function (style) {   #1
  switch (style) {
    case "latte":
    case "cappucino":
      return true;
    default:
   return false;
  }
};

var makeCoffee = function (style) {
  return style || 'Espresso';
};

var barista = function (style) {
  var now = new Date();
  var time = now.getHours();
  var coffee;
  if (hasMilk(style) && time > 12) {
    return "No";
  } else {
    coffee = makeCoffee(style);
    return "Enjoy your "+coffee+"!";
  }
};

barista("latte");
###

