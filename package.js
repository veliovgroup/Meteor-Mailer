Package.describe({
  name: 'ostrio:mailer',
  version: '1.2.3',
  summary: 'Emails queue with schedule and support of HTML-Templates, and custom SMTP connection',
  git: 'https://github.com/VeliovGroup/Meteor-Mailer',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.4');
  api.use(['mongo', 'check', 'sha', 'coffeescript', 'ecmascript', 'email'], 'server');
  api.mainModule('mailer.coffee', 'server');
  api.export('MailTime');
});