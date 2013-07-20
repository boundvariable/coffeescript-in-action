
simplesmtp = require 'simplesmtp'

class Email
  SMTP_PORT = 25
  SMTP_SERVER = 'coffeescriptinaction.com'
  constructor: (options) ->
    ['from', 'to', 'subject', 'body'].forEach (key) =>
      @["_{key}"] = options?[key]
      @[key] = (newValue) -> 
        @["_#{key}"] = newValue
        @

  send: ->
    client = simplesmtp.connect SMTP_PORT, SMTP_SERVER
    client.once 'idle', ->
      client.useEnvelope
        from: @_from
        to: @_to
    client.on 'message', ->
      client.write """
      From: "#{@_from}"
      To: #{@_to}
      Subject: #{@_subject}
  
      #{@_body}


      """
      client.end()
    @

scruffysEmail = new Email()

scruffysEmail
.to('agtron@coffeescriptinaction.com')
.from('scruffy@coffeescriptinaction.com')
.subject('Hi Agtron!')
.body '''

  This is a test email.

'''

scruffysEmail.send()
