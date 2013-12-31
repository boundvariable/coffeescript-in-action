{describe, it} = require 'chromic'

{Comments} = require '../../app/client/comments'

describe 'Comments', ->
  it 'should post a comment to the server', ->
    requested = false
    httpRequest = (url) -> requested = url
    comments = new Comments 'http://the-url', {}, httpRequest

    comment = 'Hey Agtron. Nice site.'
    comments.post comment

    requested.shouldBe "http://the-url/comments?insert=#{comment}"

  it 'should fetch the comments when constructed', ->
    requested = false
    httpRequest = (url) -> requested = url

    comments = new Comments 'http://the-url', {}, httpRequest

    requested.shouldBe "http://the-url/comments"

  it 'should bind to event on the element', ->
    comments = new Comments 'http://the-url', {}, ->

    element =
      querySelector: -> element
      value: 'A comment from Scruffy'

    comments.bind element, 'post'
    postReceived = false
    comments.post = (comment) -> postReceived = comment

    element.onpost()

    postReceived.shouldBe element.value

  it 'should render comments to the page as a list', ->
    out = innerHTML: (content) -> renderedContent = content

    comments = new Comments 'http://the-url', out, ->

    comments.render '["One", "Two", "Three"]'

    out.innerHTML.shouldBe "<ul><li>One</li><li>Two</li><li>Three</li></ul>"
