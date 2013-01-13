
class Comments
  constructor: (@url, @out, @http_request) ->
    @http_request "#{@url}/comments", @render
  post: (comment) ->
    @http_request "#{@url}/comments?insert=#{comment}", @render
  bind: (element, event) ->
    comment = element.querySelector 'textarea'
    element["on#{event}"] = =>
      @post comment.value
      false
  render: (data) =>
    in_li = (text) -> "<li>#{text}</li>"
    if data isnt ''
      comments = JSON.parse data
      if comments.map?
        formatted = comments.map(in_li).join ''
        @out.innerHTML = "<ul>#{formatted}</ul>"


exports.Comments = Comments
