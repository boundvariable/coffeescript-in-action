(function() {
  var views;

  views = {
    post: require('./post').Post,
    list: require('./list').List,
    js: require('./js').Js
  };

  exports.views = function(name, data) {
    return new views[name](data);
  };

}).call(this);
