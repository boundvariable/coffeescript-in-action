
simplesmtp = require 'simplesmtp'

class Email
  SMTP_PORT = 25
  SMTP_SERVER = 'coffeescriptinaction.com'
  constructor: ({@to, @from, @subject, @body}) ->
  send: ->
    client = simplesmtp.connect SMTP_PORT, SMTP_SERVER
    client.once 'idle', ->
      client.useEnvelope
        from: @from
        to: @to
    client.on 'message', ->
      client.write """
      From: #{@from}
      To: #{@to}
      Subject: #{@subject}

      #{@body}


      """
      client.end()


scruffysEmail = new Email
  to: 'agtron@coffeescriptinaction.com'
  from: 'scruffy@coffeescriptinaction.com'
  subject: 'Hi Agtron!'
  body: '''

  This is a test email.

  '''

scruffysEmail.send()

assert = require 'assert'
assert scruffysEmail.to is 'agtron@coffeescriptinaction.com'