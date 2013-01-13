(function() {
  var Controller;
  var __slice = Array.prototype.slice;

  Controller = (function() {
    var routes;

    routes = {};

    Controller.route = function(path, method) {
      return routes[path] = method;
    };

    function Controller(server) {
      var _this = this;
      server.on('request', function(request, response) {
        var handler, handlers, method, path, route, url, _ref, _ref2, _ref3;
        url = require('url').parse(request.url);
        path = url.pathname;
        if (url.query) path += "?" + url.query;
        handlers = [];
        for (route in routes) {
          handler = routes[route];
          if (new RegExp("^" + route + "$").test(path)) {
            handlers.push({
              handler: handler,
              matches: path.match(new RegExp("^" + route + "$"))
            });
          }
        }
        method = ((_ref = handlers[0]) != null ? _ref.handler : void 0) || 'default';
        if ((_ref2 = handlers[0]) != null ? _ref2.matches : void 0) {
          return response.end(_this[method].apply(_this, [request, response].concat(__slice.call((_ref3 = handlers[0]) != null ? _ref3.matches.slice(1) : void 0))));
        } else {
          response.writeHead(404, {
            'Content-Type': 'text/html'
          });
          return response.end('404');
        }
      });
    }

    Controller.prototype.render = function(view, mime) {
      if (mime == null) mime = 'text/html';
      this.response.writeHead(200, {
        'Content-Type': mime
      });
      return this.response.end(view.render());
    };

    Controller.prototype["default"] = function(request, response) {
      this.request = request;
      this.response = response;
      return this.render({
        render: function() {
          return 'unknown';
        }
      });
    };

    return Controller;

  })();

  exports.Controller = Controller;

}).call(this);
