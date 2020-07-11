# Hey, Listen me
[HeyListen.me](https://HeyListen.me) is a web application that search updates on Nintendo websites (game additions and game updates) and dispatch updates to other integrated applications (for now, only Twitter).

# Setup

### System Dependencies
* **Ruby**: 2.7.1
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
