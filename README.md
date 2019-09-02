# Hey, Listen me
[HeyListen.me](https://HeyListen.me) is a web application that search updates on Nintendo websites (game additions, game updates, prices drop) and dispatch updates to other integrated applications (like Twitter, Discord, Telegram, etc).

If you want to support [@stephann_v](https://twitter.com/stephann_v) and heylisten.me, please consider donating through Patreon: [https://www.patreon.com/stephannv](https://www.patreon.com/stephann)

# Roadmap
- [x] Search Nintendo Europe updates
- [x] Dispatch updates to Twitter
- [ ] Search Nintendo of America updates
- [ ] Search Nintendo Japan updates
- [ ] Search Nintendo South America (Brasil, Chile, Argentina, Colombia, etc) updates
- [ ] Import prices and notify prices drop
- [ ] Send weekly newsletter
- [ ] Webhooks - Dispatch events to third-parties
- [ ] Develop a Discord bot
- [ ] Develop a Telegram bot
- [ ] Investigate how to search updates on other Nintendo websites (China, S. Korea, etc)

# Setup

### System Dependencies
* **Ruby**: 2.6.3
* **MongoDB**: v4.2.0

### Run project
Clone project
```bash
git clone git@github.com:stephannv/heylisten.me.git
cd heylisten.me
```

Install project dependencies
```bash
bundle install
```

Schedule tasks
```
whenever --update-crontab
```

Run project
```bash
rails s -p 3000
```

Visit http://localhost:3000

# Development
To run specs
```bash
bundle exec rspec spec
```

To run rubocop
```
rubocop
```

# Using this code on own project

You can create you own application with this source code, but please:
1. **Do not** use Hey Listen Me as your application name.
2. **Do not** use logo or icons from Hey Listen Me
