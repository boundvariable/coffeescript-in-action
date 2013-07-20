{describe, it} = require 'chromic'

{Comments} = require '../../app/client/comments'

describe 'Comments', ->
  it 'should post a comment to the server', ->
    requested = false
    http_request = (url) -> requested = url
    comments = new Comments 'http://the-url', {}, http_request

    comment = 'Hey Agtron. Nice site.'
    comments.post comment

    requested.should_be "http://the-url/comments?insert=#{comment}"

  it 'should fetch the comments when constructed', ->
    requested = false
    http_request = (url) -> requested = url

    comments = new Comments 'http://the-url', {}, http_request

    requested.should_be "http://the-url/comments"

  it 'should bind to event on the element', ->
    comments = new Comments 'http://the-url', {}, ->

    element =
      querySelector: -> element
      value: 'A comment from Scruffy'

    comments.bind element, 'post'
    post_received = false
    comments.post = (comment) -> post_received = comment

    element.onpost()

    post_received.should_be element.value

  it 'should render comments to the page as a list', ->
    out = innerHTML: (content) -> rendered_content = content

    comments = new Comments 'http://the-url', out, ->

    comments.render '["One", "Two", "Three"]'

    out.innerHTML.should_be "<ul><li>One</li><li>Two</li><li>Three</li></ul>"


