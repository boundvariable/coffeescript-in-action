
class View
  render: ->
    'Lost?'

  wrap: (content='') ->
    """
    <!DOCTYPE html>
    <html dir='ltr' lang='en-US'>
    <head>
    <meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
    <script src='/application.js'></script>
    <title>Agtron's blog</title>

    #{content}

    <script>require('main').init();</script>
    """

exports.View = View
