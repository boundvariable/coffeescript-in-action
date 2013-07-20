{Controller} = require './controller'
{Post} = require '../models'
{views} = require '../views'

fs = require 'fs'

class Blog extends Controller

  @route '/', 'index'
  index: (@request, @response) =>
    @posts = Post.all()
    @render views 'list', @posts

  @route '/([a-zA-Z0-9-]+)', 'show'
  show: (@request, @response, id) =>
    @post = Post.get id
    if @post
      @render views 'post', @post
    else ''

  @route '/([a-zA-Z0-9-]+)[/]comments[?]insert=(.*)', 'insert_comment'
  insert_comment: (@request, @response, id, comment) =>
    @post = Post.get id
    if @request.method is 'POST'
      @post.comments.push comment
    @render render: => JSON.stringify(@post.comments, 'text/json')


  @route '/([a-zA-Z0-9-]+)[/]comments', 'list_comments'
  list_comments: (@request, @response, id) =>
    @post = Post.get id
    @render render: => JSON.stringify(@post.comments, 'text/json')

  @route '/(.*\.js)', 'js'
  js: (@request, @response, file) =>
    @render views('js', file), 'application/javascript'

exports.Blog = Blog
