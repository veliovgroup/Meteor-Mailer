Package.describe({
  name: 'ostrio:mailer',
  version: '2.0.3',
  summary: 'Bulletproof email queue on top of NodeMailer with support of multiple clusters and servers setup',
  git: 'https://github.com/VeliovGroup/Meteor-Mailer',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.4');
  api.use(['mongo', 'ecmascript'], 'server');
  api.mainModule('mailer.js', 'server');
});

Npm.depends({
  'mail-time': '0.1.4'
});
