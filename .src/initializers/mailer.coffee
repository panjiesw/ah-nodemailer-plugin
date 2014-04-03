###
#Mailer Initializer
*__Author__: Panjie SW <panjie@panjiesw.com>*
*__Project__: ah-nodemailer-plugin*
*__Company__: PanjieSW*

Defines ``api.Mail``
*********************************************
###

nodemailer = require 'nodemailer'
emailTemplates = require 'email-templates'
Q = require 'q'

# Console Transport pipe the email message to stdout
ConsoleTransport = (options) ->
  @options = options
  return

ConsoleTransport::sendMail = (emailMessage, callback) ->
  console.log "Envelope: ", emailMessage.getEnvelope()
  emailMessage.pipe process.stdout
  emailMessage.on "error", (err) ->
    callback err
    return

  emailMessage.on "end", ->
    callback null,
      messageId: emailMessage._messageId

    return

  emailMessage.streamMessage()
  return

Mailer = (api, next) ->
  ###
  The api is made available in ``api.Mailer`` object.
  ###
  api.Mailer =
    _start: (api, callback) ->
      config = api.config.mailer
      if config.transport is 'stdout'
        api.log "Creating stdout mail transport"
        api.Mailer.transport = nodemailer.createTransport(
          ConsoleTransport, name: 'console.local')
      else
        api.log "Creating #{config.transport} mail transport"
        api.Mailer.transport = nodemailer.createTransport(
          config.transport, config.options)
      api.log "Mailer transport created, available as ``api.Mailer.transport``"
      callback()

    ###
    Sends email with defined Mailer transport.
    ###
    send: (options, callback) ->
      config = api.config.mailer

      unless options.mail and options.template and options.locals
        throw new Error(
          "Invalid options. Must contain template, mail, and locals property")

      unless options.mail.from
        options.mail.from = config.mailOptions.from

      Q.nfcall(emailTemplates, config.templates)
      .then (template) ->
        Q.nfcall template, options.template, options.locals
      .then (resolved) ->
        options.mail.html = resolved[0]
        options.mail.text = resolved[1]
        Q.nfcall api.Mailer.transport.sendMail, options.mail
      .nodeify callback

  next()

exports.mailer = Mailer
