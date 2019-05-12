Package.describe({
  name: 'ostrio:mailer',
  version: '2.1.4',
  summary: 'Bulletproof email queue on top of NodeMailer with support of multiple clusters and servers setup',
  git: 'https://github.com/VeliovGroup/Meteor-Mailer',
  documentation: 'README.md'
});

Package.onUse((api) => {
  api.versionsFrom('1.6');
  api.use(['mongo', 'ecmascript'], 'server');
  api.mainModule('mailer.js', 'server');
});

Package.onTest((api) => {
  api.use('jquery', 'client');
  api.use(['ecmascript', 'accounts-base', 'ostrio:mailer', 'practicalmeteor:mocha', 'practicalmeteor:chai', 'meteortesting:mocha'], 'server');
  api.addFiles('tests.js', 'server');
});

Npm.depends({
  'mail-time': '1.0.5'
});
