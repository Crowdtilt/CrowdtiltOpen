# Crowdhoster

![Crowdhoster index](https://s3.amazonaws.com/crowdhoster/github_assets/readmeScreenshot.png)

"Launch your own crowdfunding site... without touching a line of code"

But if you're here—well, maybe you want to touch some code.

---
**Demo**

You can play with a complete working demo at [demo.crowdhoster.com/admin](http://demo.crowdhoster.com/admin)

Use these credentials to log in:

email: demo@crowdhoster.com | password: crowdhoster

**Quick Links:**

"I want to launch my own campaign without touching any code."

[Head to the main Crowdhoster page](http://crowdhoster.com).

"I want help customizing my Crowdhoster page."

[Check out this Crowdhoster setup guide](http://www.crowdhoster.com/setup).

"I want to contact the Crowdhoster team."

Email us directly: [team@crowdhoster.com](mailto:team@crowdhoster.com)

## Install

### Dependencies
To run Crowdhoster you'll need the following prerequisites installed:

* [Homebrew](http://mxcl.github.io/homebrew/) (for downloading software packages)

```
$ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
```
* [Git](http://git-scm.com/) (version control)

```
$ brew install git
```
* RVM, ruby 1.9.3, and the Rails gem

```
$ \curl -L https://get.rvm.io | bash -s stable --rails --ruby=1.9.3
$ rvm use 1.9.3 --default
```
* [Postgres](https://devcenter.heroku.com/articles/heroku-postgresql#local-setup) (database)

* [ImageMagick](http://www.imagemagick.org/script/index.php) (image processing software)

```
$ brew install imagemagick
```

### Service Providers
To run Crowdhoster you'll also need to sign up for the following:

* a [Balanced](https://www.balancedpayments.com/) account (test marketplace and live marketplace)
* the [Crowdtilt API](https://www.crowdtilt.com/learn/developers) - Email [support.api@crowdtilt.com](mailto:support.api@crowdtilt.com?subject=API Key Request for Crowdhoster&body=Hi! I'd like to deploy a Crowdhoster app. The Github readme sent me here to ask for an API key. Thanks!) to get your API keys
* [AWS](http://aws.amazon.com/s3/) (free) and set up a bucket for your assets. The bucket should be in the US Standard (us-east-1) zone.
* [Mailgun](http://www.mailgun.com/) (free)

### Local Setup

Get  started by:

* Downloading a .zip of the [latest release](https://github.com/Crowdtilt/Crowdhoster/releases) to your local machine

  or
 
* Creating a fork of Crowdhoster and cloning it to your local machine.



After you've got the repo on your local machine, switch to the newly created project directory

```
$ cd {DIRECTORY}
```

Create a .env file in the project root…easiest way is to create a copy of the .env.example file


```
$ cp .env.example .env
```


Then open up the .env file and fill in the variables with your app_name and credentials. Leave ```ENABLE_ASSET_SYNC``` set to 'true' if you plan to use AWS to host your assets (recommended). The bucket for asset syncing should be in the US Standard (us-east-1) zone.

The ```SECRET_TOKEN``` variable should be at least 30 characters and all random, no regular words or you'll be exposed to dictionary attacks.  You can generate a new one by running this command from the root of your project directory:

```
$ rake secret
```

Important: Your ```APP_NAME``` must not have a space in it. Underscores and hypens are accepted.

```
APP_NAME=myawesomeapp
CROWDTILT_SANDBOX_KEY=crowdtiltsandboxkey
CROWDTILT_SANDBOX_SECRET=crowdtiltsandboxsecret
ENABLE_ASSET_SYNC=true
AWS_BUCKET=awsbucket
AWS_ACCESS_KEY_ID=awsaccesskey
AWS_SECRET_ACCESS_KEY=awssecretaccesskey
MAILGUN_DOMAIN=myawesomeapp.mailgun.org
MAILGUN_PASSWORD=mailgunpassword
MAILGUN_USERNAME=postmaster@myawesomeapp.mailgun.org
SECRET_TOKEN=secrettoken
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

Push the configuration to Heroku.  
NOTE: If you have already written config vars to Heroku, they will not be overwritten unless you pass the `--overwrite` flag as well.

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

Looking to help make Crowdhoster better?

Our feature development roadmap and bugs are inputted as issues. See a complete list by [clicking here](https://github.com/Crowdtilt/Crowdhoster/issues).

Contribute by forking the repo and working on a branch. Submit your changes via pull request. 

A more complete contribution and style guide is coming soon!

## Contact and License

Want to get in touch? Email [team@crowdhoster.com](mailto:team@crowdhoster.com).

#### MIT License. Copyright 2013 Crowdtilt.
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---
Brought to you by the team at [Crowdtilt](http://crowdtilt.com) // Group fund anything
