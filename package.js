Package.describe({
  name: 'ostrio:mailer',
  version: '0.0.3',
  summary: 'Send HTML email, email templating, send emails via SMTP from SERVER ONLY',
  git: '',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3.1');
  api.addFiles('ostrio:mailer.coffee', 'server');
  api.use(['coffeescript', 'templating', 'email', 'spacebars', 'meteorhacks:ssr@2.1.1'], 'server');
});
