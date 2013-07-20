
doctype = (variant) ->
  switch variant
    when 5
      "<!DOCTYPE html>"

markup = (wrapper) ->
  (attributes..., descendents) ->
    attributesMarkup = if attributes.length is 1
     ' ' + ("#{name}='#{value}'" for name, value of attributes[0]).join ' '
    else
      ''
    "<#{wrapper}#{attributesMarkup}>#{descendents() || ''}</#{wrapper}>"

html = markup 'html'
body = markup 'body'
ul = markup 'ul'
li = markup 'li'

assert = require 'assert'

loggedIn = true

markup = html ->
  body ->
    ul class: 'info', ->
      li -> 'Logged in' if loggedIn

console.log markup
assert markup is "<html><body><ul class='info'><li>Logged in</li></ul></body></html>"