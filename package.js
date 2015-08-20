Package.describe({
  name: 'ostrio:mailer',
  version: '1.1.0',
  summary: 'Emails queue with schedule and support of HTML-Templates, and custom SMTP connection',
  git: 'https://github.com/VeliovGroup/Meteor-Mailer',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.addFiles('ostrio:mailer.coffee', 'server');
  api.use(['mongo', 'check', 'sha', 'coffeescript', 'templating', 'email', 'spacebars', 'meteorhacks:ssr@2.1.1', 'underscore', 'ostrio:jsextensions@0.0.4'], 'server');
});
