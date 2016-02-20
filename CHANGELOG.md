Changelog
=========

### [1.1.1](https://github.com/VeliovGroup/Meteor-Mailer/releases/tag/v1.1.1)
 * Major issues fixes
 * Security updates
 * Stability updates
 * Support for `cc`, `bcc`, `replyTo` options

### [1.1.0](https://github.com/VeliovGroup/Meteor-Mailer/releases/tag/v1.1.0)
 * Fix `send()` callback
 * `send()` now accepts `Object` and `callback` only (see docs)
 * `template` property in `send()` and `Meteor.Mailer()` should be plain-text or HTML with Spacebars-like placeholders, or fetched HTML via `Assets.getText()`

### [1.0.1](https://github.com/VeliovGroup/Meteor-Mailer/releases/tag/v1.0.1)
 * Add `template` support in `send()` method

### [1.0.0](https://github.com/VeliovGroup/Meteor-Mailer/releases/tag/v1.0.0)
 * Fully rewritten package
 * Based on top of Mongo
 * Better everything, please see updated docs

### [0.2.3](https://github.com/VeliovGroup/Meteor-Mailer/releases/tag/v0.2.3)
 * Deferred email sending
 * Docs update

### [0.2.2](https://github.com/VeliovGroup/Meteor-Mailer/releases/tag/v0.2.2)

 * Send emails with verbose sender if `application_config` has `appname` property
 * Fix issue if `login` has `@`
 * [Add] History.md