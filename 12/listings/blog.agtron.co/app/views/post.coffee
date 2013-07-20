
{View} = require './view'

class Post extends View
  constructor: (@post) ->
  render: ->
    @wrap """
    <h1>#{@post.title}</h1>
    <div class='content'>
    #{@post.body}
    </div>
    <div class='comments'>
    #{@post.comments}
    </div>
    <form method='post' id='comment' action=''>
    Enter your comment here:
    <textarea></textarea>
    <input type='submit' value='Comment'>
    </form>
    """


exports.Post = Post
