
views =
  post: require('./post').Post
  list: require('./list').List
  js: require('./js').Js

exports.views = (name, data) ->
  new views[name](data)
