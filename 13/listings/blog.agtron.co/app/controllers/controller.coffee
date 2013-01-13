

class Controller
  routes = {}

  @route = (path, method) ->
    routes[path] = method

  constructor: (server) ->
    server.on 'request', (request, response) =>
      url = require('url').parse(request.url)
      path = url.pathname
      if url.query then path += "?#{url.query}"
      handlers = []
      for route, handler of routes
        if new RegExp("^#{route}$").test(path)
          handlers.push
            handler: handler
            matches: path.match(new RegExp("^#{route}$"))

      method = handlers[0]?.handler || 'default'
      if handlers[0]?.matches
        response.end @[method](request, response, handlers[0]?.matches.slice(1)...)
      else
        response.writeHead 404, 'Content-Type': 'text/html'
        response.end '404'

  render: (view, mime='text/html') ->
    @response.writeHead 200, 'Content-Type': mime
    @response.end view.render()

  default: (@request, @response) ->
    @render render: -> 'unknown'


exports.Controller = Controller
