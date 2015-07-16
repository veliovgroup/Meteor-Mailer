Package.describe({
  name: 'ostrio:mailer',
  version: '0.2.3',
  summary: 'Easy peasy put emails into queue to send them within HTML-Templates via SMTP [SERVER ONLY]',
  git: 'https://github.com/VeliovGroup/Meteor-Mailer',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.addFiles('ostrio:mailer.coffee', 'server');
  api.use(['check', 'sha', 'coffeescript', 'templating', 'email', 'spacebars', 'meteorhacks:ssr@2.1.1', 'underscore', 'ostrio:jsextensions@0.0.4'], 'server');
});
