class SteamShovel
  constructor (name) ->
    @name = name
  speak = ->
    "Hurry up!"

gus = new SteamShovel
gus.speak
# Hurry up!

### Compiled with CoffeeScript 1.1.3
var SteamShovel = (function() {
  function SteamShovel(name) {
    this.name = name;
  }
  SteamShovel.prototype.speak =
    function() {
   return "Hurry up!";
 };
 return SteamShovel;
  };
gus = new SteamShovel();
gus.speak
// Hurry up!
###
