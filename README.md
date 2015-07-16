Meteor Mailer
=============
Simply sends emails via built-in Email.send method, but with support of HTML-templates and SMTP.

If there is error with email sending, like connection to SMTP, - email will be putted into queue and tried to send it 50 times after 30 seconds, retry time will be multiplied by 2 every try.

## Initialization:
```coffeescript
Meteor.mail = new Meteor.Mailer mail_config, application_config, verbose
```

###### Where `mail_config` is:
For gmail hosted mail:
```coffeescript
mail_config:
  protocol: 'smtp://'
  login: 'noreply-meteor'
  password: 'fsklfjlksejflweq21'
  host: 'smtp.gmail.com'
  port: '465'
  domain: 'gmail.com'
  connectionUrl: "smtp://noreply-meteor:fsklfjlksejflweq21@smtp.gmail.com:465"
```

For own hosted smtp server:
```coffeescript
mail_config:
  protocol: 'smtp://'
  login: 'no-reply@your-domain.com'
  password: 'dslflkads'
  host: 'smtp.domain-name.com'
  port: '587'
  domain: 'smtp.domain-name.com'
  connectionUrl: "smtp://no-reply@your-domain.com:dslflkads@smtp.domain-name.com:587"
```

###### Where `application_config` is:
```coffeescript
application_config:
  appname: "Project name" # -> Your project name
  protocol: "http://"
  domain: "localhost"
  port: "3000"
  language: "en" # -> Application localization
```

###### Where `verbose` is `boolean`:
True/false - on/off verbose mode (Server console)

## Usage
```coffee
Meteor.mail.send 'to@domain.com', options, callback
```

__Note:__ if `Template` is not set, email will be sent within our default cute and sleek built-in template.

###### Where `options` is:
```coffeescript
options:
 template: "`Template` should be HTML or JADE template with variables (read: placeholders)"
 message: "Some HTML or plain-text string (required)"
 subject: "Some HTML or plain-text string (required)"
 #Any optional keys, like
 appname: "Your application name"
 url: "http://localhost:3000"

Example:
```html
<html lang="{{lang}}">
  <head>
    ...
    <title>{{Subject}}</title>
  </head>
  <body>
    <h3>{{{Subject}}}</h3>
    <p>{{{Message}}}</p>
    <footer>
      <a href="{{url}}">{{appname}}</a>
    </footer>
  </body>
</html>
```

###### Where `callback` is:
```coffeescript
callback = (error, success, recipient) ->
  console.log("mail is not sent to #{recipient}") if error
  console.log("mail successfully sent to #{recipient}") if success
```