(function() {
  var Blog, blog, config, http, load, server;

  http = require('http');

  load = require('./load').load;

  Blog = require('./controllers').Blog;

  load('./content');

  if (!process.env.NODE_ENV) throw new Error('No evironment defined');

  config = require('./config')[process.env.NODE_ENV];

  if (config == null) process.exit();

  server = new http.Server();

  server.listen(config.port, config.host);

  blog = new Blog(server);

}).call(this);
