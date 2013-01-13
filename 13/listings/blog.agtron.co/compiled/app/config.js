(function() {
  var config, key, value;

  config = {
    development: {
      host: 'localhost',
      port: '8080'
    },
    production: {
      host: 'blog.agtron.co',
      port: '80'
    }
  };

  for (key in config) {
    value = config[key];
    exports[key] = value;
  }

}).call(this);
