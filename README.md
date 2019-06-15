# Meteor Mailer (MailTime)

__301: This package is moved to the main repository of [NPM version](https://github.com/VeliovGroup/Mail-Time), but still can be installed via Atmosphere as Meteor package!__

## Main features:

- 📦 Two simple dependencies, written from scratch for top performance
- 😎 Synchronize email queue across multiple servers
- 💪 Bulletproof design, built-in retries

## How does it work?:

### Single point of failure

Issue - classic solution with single point of failure:

```ascii
|----------------|         |------|         |------------------|
|  Other mailer  | ------> | SMTP | ------> |  ^_^ Happy user  |
|----------------|         |------|         |------------------|

The cheme above will work as long as SMTP service is available
or connection between your server and SMPT is up. Once network
failure occurs or SMTP service is down - users won't be happy

|----------------|  \ /    |------|         |------------------|
|  Other mailer  | --X---> | SMTP | ------> | 0_o Disappointed |
|----------------|  / \    |------|         |------------------|
                     ^- email lost in vain

Single SMTP solution may work in case of network or other failures
As long as MailTime has not received confirmation what email is sent
it will keep the letter in the queue and retry to send it again

|----------------|    /    |------|         |------------------|
|   Mail Time    | --X---> | SMTP | ------> |  ^_^ Happy user  |
|---^------------|  /      |------|         |------^-----------|
     \-------------/ ^- We will try later         /
      \- put it back into queue                  /
       \----------Once connection is back ------/
```

### Multiple SMTP providers

Backup scheme with multiple SMTP providers

```ascii
                           |--------|
                     /--X--| SMTP 1 |
                    /   ^  |--------|
                   /    \--- Retry with next provider
|----------------|/        |--------|         |------------------|
|   Mail Time    | ---X--> | SMTP 2 |      /->|  ^_^ Happy user  |
|----------------|\   ^    |--------|     /   |------------------|
                   \  \--- Retry         /
                    \      |--------|   /
                     \---->| SMTP 3 |--/
                           |--------|
```

### Cluster issue

Let's say you have an app which is growing fast. At some point, you've decided to create a "Cluster" of servers to balance the load and add durability layer.

Also, your application has scheduled emails, for example, once a day with recent news. While you have had single server emails was sent by some daily interval. So, after you made a "Cluster" of servers - each server has its own timer and going to send a daily email to our user. In such case - users will receive 3 emails, sounds not okay.

Here is how we solve this issue:

```ascii
|===================THE=CLUSTER===================| |=QUEUE=| |===Mail=Time===|
| |----------|     |----------|     |----------|  | |       | |=Micro-service=|   |--------|
| |   App    |     |   App    |     |   App    |  | |       | |               |-->| SMTP 1 |------\
| | Server 1 |     | Server 2 |     | Server 3 |  | |    <--------            |   |--------|       \
| |-----\----|     |----\-----|     |----\-----|  | |    -------->            |                |-------------|
|        \---------------\----------------\---------->      | |               |   |--------|   |     ^_^     |
| Each of the "App Server" or "Cluster Node"      | |       | |               |-->| SMTP 2 |-->| Happy users |
| runs Mail Time as a Client which only puts      | |       | |               |   |--------|   |-------------|
| emails into the queue. Aside to "App Servers"   | |       | |               |                    /
| We suggest running Mail Time as a Micro-service | |       | |               |   |--------|      /
| which will be responsible for making sure queue | |       | |               |-->| SMTP 3 |-----/
| has no duplicates and to actually send emails   | |       | |               |   |--------|
|=================================================| |=======| |===============|
```

## Features

- Queue - Managed via MongoDB, and will survive server reboots and failures
- Support for multiple server setups - "Cluster", Phusion Passenger instances, Load Balanced solutions, etc.
- Emails concatenation by addressee email - Reduce amount of sent email to single user with concatenation, and avoid mistakenly doubled emails
- When concatenation is enabled - Same emails wouldn't be sent twice, if for any reason, due to bad logic or application failure emails is sent twice or more times - here is solution to solve this annoying behavior
- Balancing for multiple nodemailer's transports, two modes - `backup` and `balancing`. Most useful feature - allows to reduce the cost of SMTP services and add durability. So, if any of used transports are failing to send an email it will switch to next one
- Sending retries for network and other failures
- Template support with Mustache-like placeholders

## Prerequisites

If you're working on Server functionality - first you will need `nodemailer`, although this package is meant to be used with `nodemailer`, it's not added as the dependency, as it not needed by Client, and you're free to choose `nodemailer`'s version to fit your needs:

```shell
meteor npm install --save nodemailer
```

## Installation & Import (*via Atmosphere*):

Install *MailTime* package:

```shell
meteor add ostrio:mailer
```

ES6 Import:

```js
import MailTime from 'meteor/ostrio:mailer';
```

## Installation & Import (*via NPM*):

Install *MailTime* package:

```shell
meteor npm install --save mail-time
```

ES6 Import:

```js
import MailTime from 'mail-time';
```

Please see full documentation at [`mail-time`](https://github.com/VeliovGroup/Mail-Time) project page

## Support this project:

- [Become a patron](https://www.patreon.com/bePatron?u=20396046) — support my open source contributions with monthly donation
- Use [ostr.io](https://ostr.io) — [Monitoring](https://snmp-monitoring.com), [Analytics](https://ostr.io/info/web-analytics), [WebSec](https://domain-protection.info), [Web-CRON](https://web-cron.info) and [Pre-rendering](https://prerendering.com) for a website
