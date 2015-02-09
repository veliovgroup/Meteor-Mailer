Package.describe({
  name: 'ostrio:mailer',
  version: '0.1.1',
  summary: 'Easy peasy email sending within HTML-Templates via SMTP [SERVER ONLY]',
  git: 'https://github.com/VeliovGroup/Meteor-Mailer',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3.1');
  api.addFiles('ostrio:mailer.coffee', 'server');
  api.use(['coffeescript', 'templating', 'email', 'spacebars', 'meteorhacks:ssr@2.1.1', 'underscore', 'ostrio:jsextensions@0.0.4'], 'server');
});
