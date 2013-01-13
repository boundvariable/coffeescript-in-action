(function() {
  var Post, describe, it, _ref;

  _ref = require('chromic'), describe = _ref.describe, it = _ref.it;

  Post = require('../../app/models/post').Post;

  describe('Post', function() {
    it('should return all posts', function() {
      Post.purge();
      new Post('A post', 'with contents');
      new Post('Another post', 'with contents');
      return Post.all().length.should_be(2);
    });
    return it('should return a specific post', function() {
      var post;
      Post.purge();
      post = new Post('Elephant Stampede', 'Contents');
      return Post.get(post.slug).should_be(post);
    });
  });

}).call(this);
