var hasMilk = function (style) {
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
