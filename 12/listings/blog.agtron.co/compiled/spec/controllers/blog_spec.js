(function() {
  var Blog, Post, describe, http, it, _ref;

  http = require('http');

  _ref = require('chromic'), describe = _ref.describe, it = _ref.it;

  Blog = require('../../app/controllers').Blog;

  Post = require('../../app/models').Post;

  describe('Blog controller', function() {
    var blog, response, server, setup;
    server = {};
    blog = {};
    response = {};
    setup = function() {
      server = new http.Server;
      blog = new Blog(server);
      return response = (new http.ServerResponse({})).double;
    };
    return it('should write headers and end response', function() {
      setup();
      response.should_receive('writeHead');
      response.should_receive('end');
      return server.emit('request', {
        url: '/'
      }, response);
    });
  });

}).call(this);
