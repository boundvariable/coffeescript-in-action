class Simple
  constructor: ->
    @name = "simple object"

### Compiled with CoffeeScript 1.1.3
simple = new Simple	var Simple = (function() {
  function Simple() {
    this.name = 'simple';
  }
  return Simple;
})();

simple = new Simple();
###
