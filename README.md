Meteor Mailer
=============
Simply sends emails via built-in Email.send method, but with support of HTML-templates and SMTP.

## Initialization:
```coffeescript
Meteor.mail = new Meteor.Mailer mail_config, application_config
```

###### Where `mail_config` is:
```coffeescript
mail_config:
  protocol: 'smtp://'
  login: 'noreply-meteor'
  password: 'fsklfjlksejflweq21'
  host: 'smtp.gmail.com'
  port: '465'
  domain: 'gmail.com'
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

## Usage
```coffee
Meteor.mail.send 'to@domain.com', 'subject', 'Plain text or HTML-message', Template, callback
```

__Note:__ if `Template` is not set, email will be sent within our default cute and sleek built-in template.

###### Where `Template` is:
`Template` should be HTML or JADE template with next variables (read: placeholders) - `message` (required), `lang` (optional), `subject` (optional), like: 
```html
<html lang="{{lang}}">
  <head>
    ...
    <title>{{Subject}}</title>
  </head>
  <body>
    <h3>{{{Subject}}}</h3>
    <p>{{{Message}}}</p>
  </body>
</html>
```

###### Where `callback` is:
```coffeescript
callback = (error, success, recipient) ->
  console.log "mail is not sent to #{recipient}" if error
  console.log "mail successfully sent to #{recipient}" if success
```