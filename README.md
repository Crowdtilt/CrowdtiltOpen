# Crowdhoster 
### A ![Crowdhoster by Crowdtilt](https://raw.github.com/mattlebel/Crowdhoster/master/app/assets/images/by_crowdtilt.png) project
---

![Crowdhoster index](https://raw.github.com/mattlebel/Crowdhoster/master/app/assets/images/readmeScreenshot.png)

"Launch your own crowdfunding site...without touching a line of code"

Well, if you're here, maybe you want to touch *some* of the code.

---
Quick Links:

"I want to launch my own campaign without touching any code." - [Head to the main Crowdhoster page](http://crowdhoster.com).      
"I want help customizing my Crowdhoster page." - [Check out this Crowdhoster setup guide](http:crowdhostersetup.herokuapp.com).    
"I want to contact the Crowdhoster team." - Email us directly: [team@crowdhoster.com](mailto:team@crowdhoster.com)

## Install

### Dependencies
To run Crowdhoster you'll need the following prerequisites installed:

* [Homebrew](http://mxcl.github.io/homebrew/)    
```
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
```
* [Git](http://git-scm.com/)   
```
brew install git
```
* RVM, ruby 1.9.3, and the Rails gem    
```
\curl -L https://get.rvm.io | bash -s stable --rails --ruby=1.9.3
rvm use 1.9.3 --default
```
* Install [Postgres](https://devcenter.heroku.com/articles/heroku-postgresql#local-setup)    
* Install [ImageMagick](http://www.imagemagick.org/script/index.php)    
```
brew install imagemagick
```

### Service Providers
To run Crowdhoster you'll also need to complete the following:

* Sign up for a [Balanced](https://www.balancedpayments.com/) account (test marketplace and live marketplace)    
* Sign up for the [Crowdtilt API](https://www.crowdtilt.com/learn/developers) - Email [support.api@crowdtilt.com](mailto:support.api@crowdtilt.com) to get your API keys    
* Sign up for [AWS](http://aws.amazon.com/s3/) (free) and set up a bucket for your assets    
* Sign up for [Mailgun](http://www.mailgun.com/) (free)    

### Local Setup

Clone the Crowdhoster repo into a new directory    
```
$ git clone https://github.com/Crowdtilt/selfstarter.git {DIRECTORY}
```

If you haven't already, create a .env file in the root directory of the app and fill it with the following:  
```

APP_NAME=myawesomeapp
CROWDTILT_SANDBOX_KEY=crowdtiltsandboxkey
CROWDTILT_SANDBOX_SECRET=crowdtiltsandboxsecret
CROWDTILT_PRODUCTION_KEY=crowdtiltproductionkey
CROWDTILT_PRODUCTION_SECRET=crowdtiltproductionsecret
ENABLE_ASSET_SYNC=true
AWS_BUCKET=awsbucket
AWS_ACCESS_KEY_ID=awsaccesskey
AWS_SECRET_ACCESS_KEY=awssecretaccesskey
MAILGUN_DOMAIN=myawesomeapp.mailgun.org
MAILGUN_PASSWORD=mailgunpassword
MAILGUN_USERNAME=postmaster@myawesomeapp.mailgun.org
```

Install the gems    
```
$ bundle install
```

Create and migrate the DB    
```
$ foreman run rake db:create
$ foreman run rake db:migrate
```

Start the server    
```
$ foreman start
```

Run the console    
```
$ foreman run rails c
```

### Deploying to Heroku

1. [Sign up for a Heroku Account](https://www.heroku.com/)    
2. [Install the Heroku Toolbelt](https://toolbelt.heroku.com/)    

Create a new Heroku app    
```
$ heroku create {APP NAME}
```

Enable the use of environment variables during asset precompiling    
```
$ heroku labs:enable user-env-compile
```

Install the Heroku config plugin if you don't already have it installed    
```
$ heroku plugins:install git://github.com/ddollar/heroku-config.git

```

Push the configuration to Heroku    
```
$ heroku config:push 
```

Deploy the code to Heroku    
```
$ git push heroku master
```

Migrate the database    
```
$ heroku run rake db:migrate
```

Launch the app!    
```
$ heroku open
```

## Contribute

Coming soon!

Can't wait? Email [team@crowdhoster.com](mailto:team@crowdhoster.com).

## Contact, Credits, and License

Want to get in touch? Email [team@crowdhoster.com](mailto:team@crowdhoster.com).
