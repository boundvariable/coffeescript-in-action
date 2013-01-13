
http_request = (url, callback) ->
  http = new XMLHttpRequest
  http.open 'POST', url, true
  http.onreadystatechange = ->
    if http.readyState is 4 then callback http.responseText
  http.send()

init = ->
  comment_form = document.querySelector('#comment')
  if comment_form?
    {Comments} = require './comments'
    comments_node = document.querySelector '.comments'
    comments = new Comments(window.location.href, comments_node, http_request)
    comments.bind comment_form, 'submit'

exports.init = init


