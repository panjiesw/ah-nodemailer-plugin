###
#Send Mail Task
*__Author__: Panjie SW <panjie@panjiesw.com>*
*__Project__: ah-nodemailer-plugin*
*__Company__: PanjieSW*

Defines simple task to send email with nodemailer.
*********************************************
###

exports.sendMail =
  name: 'sendMail'
  description: "Send welcome email to newly signed up user
    with further instruction to activate their account"
  queue: 'default'
  plugins: []
  pluginOptions: []
  frequency: 0
  ###
  Run sendMail task.
  ###
  run: (api, params, next) ->
    api.Mailer.send(params)
    .then (response) ->
      api.log "Mail sent to #{params.mail.to}"
      next null, response
    .catch (err) ->
      api.log "Error sending mail", 'crit', err.message
      api.log err.stack, 'error'
      next err, null
