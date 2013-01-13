{describe, it} = require 'chromic'

{Post} = require '../../app/models/post'

describe 'Post', ->

  it 'should return all posts', ->
    Post.purge()
    new Post 'A post', 'with contents'
    new Post 'Another post', 'with contents'

    Post.all().length.should_be 2

  it 'should return a specific post', ->
    Post.purge()
    post = new Post 'Elephant Stampede', 'Contents'
    Post.get(post.slug).should_be post

