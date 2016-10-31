Meteor Mailer (MailTime)
=============
Send emails via built-in `Email.send()` method, but with support of HTML-templates, SMTP and Queue + retries. If there is error with email sending, like connection to SMTP, - letter will be placed into queue and tried to send it 50 times with progressive interval up to 60 seconds.

ES6 Import:
======
```jsx
import { MailTime } from 'meteor/ostrio:mailer';
```

Initialize:
======
```js
Mailer = new MailTime(options);
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
   * if is not set, email will be sent within our default sleek built-in template
   * `template` should be plain-text or HTML with Spacebars-like placeholders

#### Example:
For gmail hosted mail:
```js
Mailer = new MailTime({
  login: 'noreply-meteor',
  host: 'gmail.com',
  connectionUrl: 'smtp://account:password@smtp.gmail.com:465',
  accountName: 'My Project MailBot',
  verbose: true,
  intervalTime: 120,
  retryTimes: 10,
  saveHistory: true,
  template: 'Plain-text or HTML with Spacebars-like placeholders'
});
```

For own hosted smtp server:
```js
Mailer = new MailTime({
  login: 'no-reply@example.com',
  host: 'smtp.example.com',
  connectionUrl: 'smtp://no-reply@example.com:password@smtp.example.com:587',
  accountName: 'My Project MailBot'
});
```

Send:
======
#### `.send()` method
```js
Mailer = new MailTime({/* .. */});
Mailer.send(options, callback);
```
 - `options` {*Object*}:
  - `to` {*String*} - [*required*] Recipient email address
  - `cc` {*String*} - [*optional*] Recipient email address
  - `bcc` {*String*} - [*optional*] Recipient email address
  - `replyTo` {*String*} - [*optional*] Recipient email address
  - `subject` {*String*} - [*required*] Plain text or HTML
  - `message` {*String*} - [*required*] Plain text or HTML with placeholders
  - `sendAt` {*Date*} - Date when email should be sent. By default - current time
  - `template` {*String*} - Plain-text or HTML with Spacebars-like placeholders
    * if is not set, by default email will be sent within `template` passed via initialization options or our default template
    * `template` should be plain-text or HTML with Spacebars-like placeholders
 - `callback` {*Function*} - [Optional] Arguments `error`, `success` and `recipient` arguments. __Note__: There is no way to use this callback function in multi-server infrastructure, callbacks is stored in-memory and will be wiped upon server restart. *Primary usage for callback is debugging, __do not use for logic/algorithm/etc.__*

#### Example:
```js
Mailer.send({
  to: 'to@example.com',
  message: 'Some HTML or plain-text string (required)',
  subject: 'Some HTML or plain-text string (required)',
  template: '<html> <head> <title>{{Subject}}</title> </head> <body> <h3>{{{Subject}}}</h3> <p>{{{Message}}}</p></body></html>',
}, function(error, success, recipient) {
  if (error) {
    console.log("mail is not sent to " + recipient);
  }
  if (success) {
    return console.log("mail successfully sent to " + recipient);
  }
});
```

#### Template example (should be passed to `template` as *String*):
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