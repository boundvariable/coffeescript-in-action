
class Comments
  constructor: (@url, @out, @httpRequest) ->
    @httpRequest "#{@url}/comments", @render
  post: (comment) ->
    @httpRequest "#{@url}/comments?insert=#{comment}", @render
  bind: (element, event) ->
    comment = element.querySelector 'textarea'
    element["on#{event}"] = =>
      @post comment.value
      false
  render: (data) =>
    inLi = (text) -> "<li>#{text}</li>"
    if data isnt ''
      comments = JSON.parse data
      if comments.map?
        formatted = comments.map(inLi).join ''
        @out.innerHTML = "<ul>#{formatted}</ul>"


exports.Comments = Comments
