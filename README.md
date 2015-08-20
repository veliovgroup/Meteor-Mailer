Meteor Mailer
=============
Simply sends emails via built-in Email.send method, but with support of HTML-templates and SMTP.

If there is error with email sending, like connection to SMTP, - letter will be placed into queue and tried to send it 50 times after 60 seconds.

## Initialization:
```coffeescript
Meteor.mail = new Meteor.Mailer options
```

`options` {*Object*} - Object with next properties:
 - `login` {*String*} - [required] Your login on SMTP server, ex.: `no-reply`
 - `host` {*String*} - [required] Domain name or IP-address of SMTP server, ex.: `smtp.example.com`
 - `connectionUrl` {*String*} - [required] Connection (auth) URL with login, password and port, ex.: `smtp://account:password@smtp.gmail.com:465`
 - `accountName` {*String*} - Name of the account (usually shown next to or instead of email address). By default equals to `login` property, ex.: `Some Service Name Support`
 - `intervalTime` {*Number*} - How often try to send an email in seconds. By default `60` seconds, ex.: `600`
 - `retryTimes` {*Number*} - How many times to retry to send email. By default `50`, ex.: `10`
 - `saveHistory` {*Boolean*} - Save sent emails. By default `false`, ex.: `true`
 - `verbose` {*Boolean*} - Show messages of sending/pending into server's console. By default `false`, ex.: `true`
 - `template` {*String*} - Plain-text or HTML with Spacebars-like placeholders
  - if is not set, email will be sent within our default cute and sleek built-in template
  - `template` should be plain-text or HTML with Spacebars-like placeholders, or fetched HTML via `Assets.getText()`
  - read more [about assets](http://docs.meteor.com/#/full/assets_getText)

###### Example:
For gmail hosted mail:
```coffeescript
Meteor.mail = new Meteor.Mailer
  login: 'noreply-meteor'
  host: 'gmail.com'
  connectionUrl: "smtp://account:password@smtp.gmail.com:465"
  accountName: "My Project MailBot"
  verbose: true
  intervalTime: 120
  retryTimes: 10
  saveHistory: true
  template: 'Plain-text or HTML with Spacebars-like placeholders'
```

For own hosted smtp server:
```coffeescript
Meteor.mail = new Meteor.Mailer
  login: 'no-reply@example.com'
  host: 'smtp.example.com'
  connectionUrl: "smtp://no-reply@example.com:password@smtp.example.com:587"
  accountName: "My Project MailBot"
```

## Usage
#### `send()` method
```coffee
Meteor.mail.send options, callback
```
 - `options` {*Object*}:
  - `to` {*String*} - Recipient email address
  - `subject` {*String*} - [required] Plain text or HTML
  - `message` {*String*} - [required] Plain text or HTML with placeholders
  - `sendAt` {*Date*} - Date when email should be sent. By default - current time
  - `template` {*String*} - Plain-text or HTML with Spacebars-like placeholders
    - if is not set, by default email will be sent within `template` passed via initialization options or our default template
    - `template` should be plain-text or HTML with Spacebars-like placeholders, or fetched HTML via `Assets.getText()`
    - read more [about assets](http://docs.meteor.com/#/full/assets_getText)
 - `callback` {*Function*} - With `error`, `success` and `recipient` parameters

###### Example:
```coffeescript
Meteor.mail.send 
  to: 'to@example.com'
  message: "Some HTML or plain-text string (required)"
  subject: "Some HTML or plain-text string (required)"
  #Any optional keys, like
  template: Assets.getText 'path/to/your/template.html'
  appname: "Your application name"
  url: "http://localhost:3000"
  lang: 'en'
,
  (error, success, recipient) ->
    console.log("mail is not sent to #{recipient}") if error
    console.log("mail successfully sent to #{recipient}") if success
```

###### Template example:
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
