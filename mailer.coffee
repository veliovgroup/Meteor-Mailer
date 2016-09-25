mailQueue = new Mongo.Collection "__mailQueue__"
mailQueue._ensureIndex {uid: 1, sendAt: 1, isSent: 1, tries: 1}, {background: true}

mailQueue.deny
  insert: -> true
  update: -> true
  remove: -> true

###
@class Mailer
@description Wrapper around Email to ease the usage
###
class Meteor.Mailer
  ###
  @namespace Mailer
  @param {Object} settings - Connection, sending and other settings
  @description For more info about constrictor options see README.md and docs
  ###
  constructor: (settings = {}) ->
    check settings, Object
    {@login, @host, @connectionUrl, @accountName, @verbose, @intervalTime, @saveHistory, @retryTimes, @template} = settings if Object.keys(settings).length
    check @login, String
    check @host, String
    check @connectionUrl, String
    
    @queue         = {}
    @callbacks     = {}

    @accountName  ?= @login
    @verbose      ?= false
    @intervalTime ?= 60
    @saveHistory  ?= false
    @retryTimes   ?= 50
    @template     ?= false
    @uid           = SHA256 (@connectionUrl or process.env.MAIL_URL) + @accountName + @login

    process.env.MAIL_URL = @connectionUrl or process.env.MAIL_URL
    Meteor.setInterval @queueTry, @intervalTime * 1000


  queueAdd: (opts, callback) =>
    cbKey = false
    if callback
      cbKey = SHA256 "#{opts.to}#{opts.subject}#{opts.sendAt}#{@uid}"
      @callbacks[cbKey] = callback

    _id = mailQueue.insert
      uid:      @uid
      opts:     opts
      to:       opts.to
      subject:  opts.subject
      template: opts.template
      sendAt:   opts.sendAt
      isSent:   false
      tries:    0
      callback: cbKey

    @queueTry _id
    return

  queueTry: (_id = false) =>
    if _id
      emailsToSend = mailQueue.find _id
    else
      emailsToSend = mailQueue.find
        uid: @uid
        sendAt: $lte: new Date()
        isSent: false
        tries: $lt: @retryTimes

    if emailsToSend and emailsToSend.count() > 0
      _self = @
      emailsToSend.forEach (letter) -> Meteor.defer ->
        try
          Email.send
            from: if !!~_self.login.indexOf('@') then "<#{_self.login}> #{_self.accountName}" else "<#{_self.login}@#{_self.host}> #{_self.accountName}"
            to:      letter.to
            cc:      letter.opts?.cc
            bcc:     letter.opts?.bcc
            replyTo: letter.opts?.replyTo
            subject: letter.subject.replace /<(?:.|\n)*?>/gm, ''
            html:    _self.compileBody letter.opts, letter.template

          if letter.callback and _self.callbacks[letter.callback]
            _self.callbacks[letter.callback] null, true, letter.to
            delete _self.callbacks[letter.callback]

          if _self.saveHistory
            mailQueue.update 
              _id: letter._id
            ,
              $set: 
                isSent: true
          else
            mailQueue.remove _id: letter._id

          console.info "Email was successfully sent to #{letter.to}" if _self.verbose
        catch e
          console.info "Email wasn't sent to #{letter.to}", e if _self.verbose
          mailQueue.update 
            _id: letter._id
          ,
            $inc: tries: 1

          if letter.callback and _self.callbacks?[letter.callback]
            _self.callbacks[letter.callback] {error: e}, false, letter.to
          console.info "Trying to send email to #{letter.to} again for #{++letter.tries} time(s)" if _self.verbose
        return

  ###
  @namespace Mailer
  @method send
  @param  {Object} opts - Sending options object with next arguments:
      {String} recipient  - E-mail address of recipient
      {String} subject    - Letter Subject (plain-text or HTML)
      {String} message    - Letter Message (plain-text or HTML)
      {String} template   - [OPTIONAL] Plain-text or HTML with Spacebars-like placeholders
      {Date}   sendAt     - [OPTIONAL] When email should be sent (current time - by default)
      [{String}..]        - Any other property as a String which will be used as template helpers
      {Function} callback - Callback function: `function(error, success, recipientEmail)`
  ###
  send: (opts, callback = false) =>
    opts.sendAt ?= new Date

    check opts, Object
    check opts.to, String
    check opts.cc, Match.Optional String
    check opts.bcc, Match.Optional String
    check opts.replyTo, Match.Optional String
    check opts.subject, String
    check opts.message, String
    check opts.sendAt, Date

    @queueAdd opts, callback
    return

  ###
  @namespace Mailer
  @method  compileBody
  @param  {Object} helpers
    Options opts {object} containing:
    @param  {String} subject - Letter subject
    @param  {String} message - Message text, letter body
    @param  {String} lang    - [OPTIONAL] Language
    @param  {String} template- [OPTIONAL] Plain-text or HTML with Spacebars-like placeholders
  ###
  compileBody: (helpers={}, template) =>
    if template
      tmplt = template
    else
      tmplt = if not @template then @basicHTMLTempate else @template

    return renderReplace tmplt, helpers

  renderReplace = (string, replacements) ->
    matchHTML = string.match /\{{3}\s?([a-z0-9\-\_]+)\s?\}{3}/g
    for html in matchHTML
      if replacements[html.replace("{{{", "").replace("}}}", "").trim()]
        string = string.replace html, replacements[html.replace("{{{", "").replace("}}}", "").trim()]

    matchStr  = string.match /\{{2}\s?([a-z0-9\-\_]+)\s?\}{2}/g
    for str in matchStr
      if replacements[str.replace("{{", "").replace("}}", "").trim()]
        string = string.replace str, replacements[str.replace("{{", "").replace("}}", "").trim()].replace(/<(?:.|\n)*?>/gm, '');
    return string

  basicHTMLTempate: '<html lang="{{lang}}" style="padding:10px 0px;margin:0px;width:100%;background-color:#ececec;"><head> <meta charset="utf-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> <title>{{{subject}}}</title> <meta name="viewport" content="width=device-width"> <style type="text/css"> html{font-size:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%}::-moz-selection{background:rgba(0,0,0,0.2);color:#fff;text-shadow:none}::selection{background:rgba(0,0,0,0.2);color:#fff;text-shadow:none}a:focus{outline:0}a:hover,a:active{outline:0}abbr[title]{border-bottom:1px dotted}b,strong{font-weight:bold}small{font-size:85%}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline}sup{top:-0.5em}sub{bottom:-0.25em}ul,ol{margin:1em 0;padding:0 0 0 40px}table{border-collapse:collapse;border-spacing:0}td{vertical-align:top}body{font-family:"Lucida Grande",Helvetica,Arial,Verdana,sans-serif;font-size:13px;color:#2b2b2b;line-height:20px;background-color:#ececec;text-shadow:1px 1px rgba(255,255,255,.95)}.wrapper{max-width:546px;margin:26px auto;background-color:#fafafa;-webkit-border-radius:6px;-moz-border-radius:6px;border-radius:6px;box-shadow:0px 1px 1px #ccc;box-shadow:0px 1px 5px rgba(0, 0, 0, 0.1);padding:5px;border:1px solid rgba(0,0,0,0.2);}a,a:visited{color:#b0b3b9}a:hover{color:#b0b3b9}.footer{text-align:center;font-size:11px;color:#b0b3b9;line-height:14px;text-shadow:1px 1px #fff;text-shadow:1px 1px rgba(255,255,255,.5)}.footer a,.footer a:visited{color:#b0b3b9;font-weight:bold}.main{padding:15px;-webkit-border-radius:8px;-moz-border-radius:8px;border-radius:8px;box-shadow:inset 0px 0px 1px #ccc;box-shadow:inset 0px 0px 1px rgba(0,0,0,0.4);border:1px solid rgba(0,0,0,0.2);}h2{font-weight:200; color:#222;}hr{display:block;height:1px;border:0;border-top:1px solid #ccc;border-top:1px solid rgba(0,0,0,0.2);margin:1em -16px;padding:0}</style></head><body style="padding:10px 0px;margin:0px;width:100%;background-color:#ececec;"> <div style="font-family:\'Lucida Grande\',Helvetica,Arial,Verdana,sans-serif;font-size:13px;color:#2b2b2b;line-height:20px;background-color:#ececec;text-shadow:1px 1px rgba(255,255,255,.95);"> <div class="wrapper" style="max-width:546px;margin:26px auto;background-color:#fafafa;-webkit-border-radius:6px;-moz-border-radius:6px;border-radius:6px;box-shadow:0px 1px 1px #ccc;box-shadow:0px 1px 5px rgba(0, 0, 0, 0.1);padding:5px;border:1px solid rgba(0,0,0,0.2);"> <div class="main" style="padding:15px;-webkit-border-radius:8px;-moz-border-radius:8px;border-radius:8px;box-shadow:inset 0px 0px 1px #ccc;box-shadow:inset 0px 0px 1px rgba(0,0,0,0.4);border:1px solid rgba(0,0,0,0.2);"> <table bgcolor="fafafa" font-color="2b2b2b" width="100%" cellspacing="0" celladding="0" border="0"> <tbody> <tr> <td> <h2 style="font-weight:200">{{{subject}}}</h2> <hr style="display:block;height:1px;border:0;border-top:1px solid #ccc;border-top:1px solid rgba(0,0,0,0.2);margin:1em -16px;padding:0"> </td></tr><tr> <td> <p>{{{message}}}</p></td></tr></tbody> </table> </div></div><div class="footer" align="center" width="100%" style="font-size:11px;color:#b0b3b9;line-height:14px;text-shadow:1px 1px #fff;text-shadow:1px 1px rgba(255,255,255,.5)"> <table bgcolor="ececec" color="b0b3b9" height="100%" width="100%" cellspacing="0" celladding="0" border="0"> <tbody> <tr> <td align="center"> All rights belongs to site owner.<br/> <a style="color:#b0b3b9;font-weight:bold" href="{{url}}">{{appname}}</a> </td></tr></tbody> </table> </div></div></body></html>'