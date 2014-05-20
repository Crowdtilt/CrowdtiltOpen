# Crowdtilt Open

Launch your own advanced crowdfunding page.

---
**Demo**

You can play with a complete working demo at [open.crowdtilt.com](http://open.crowdtilt.com)

**Quick Links:**

Want to launch your campaign without touching any code? [Head to the main Crowdtilt Open page](http://open.crowdtilt.com).

Have questions? Email us directly: [open@crowdtilt.com](mailto:open@crowdtilt.com)

## Install

### Dependencies
To run Crowdtilt Open you'll need the following prerequisites installed:

* [Homebrew](http://brew.sh/) (for downloading software packages)

```
$ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
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

* If you recently upgraded to OS X Mavericks (10.9) or got a new Mac computer and are having issues with the json gem during the bundle process, you may need to install the Command Line Developer Tools using the following command and clicking Install when prompted:

```
$ xcode-select --install
```

### Service Providers
To run Crowdtilt Open, you'll also need to do the following:

* Email [support.api@crowdtilt.com](mailto:support.api@crowdtilt.com?subject=API Key Request for Crowdtilt Open&body=Hi! I'd like to deploy a Crowdtilt Open app. The Github readme sent me here to ask for an API key. Thanks!) to get your Crowdtilt API keys
* Create an [Amazon Web Services S3 account](http://aws.amazon.com/s3/) (free) and set up a bucket for your assets. The bucket should be in the US Standard (us-east-1) zone.
* Sign up for [Mailgun](http://www.mailgun.com/) (free)
* When you're ready to activate payments, sign up for a [Balanced Payments](https://www.balancedpayments.com/) account.

### Local Setup

Get  started by:

* Downloading a .zip of the [latest release](https://github.com/Crowdtilt/CrowdtiltOpen/releases) to your local machine

  or

* Creating a fork of Crowdtilt Open and cloning it to your local machine.



After you've got the repo on your local machine, switch to the newly created project directory

```
$ cd {DIRECTORY}
```

Create a .env file in the project root…easiest way is to create a copy of the .env.example file


```
$ cp .env.example .env
```


Then open up the .env file and fill in the variables with your app_name and credentials. Leave `ENABLE_ASSET_SYNC` set to 'true' if you plan to use AWS to host your assets (recommended). The bucket for asset syncing should be in the US Standard (us-east-1) zone.

Generate your `SECRET_TOKEN`  and `DEVISE_SECRET_KEY` by running the following command from the root of your project directory. 

Do NOT reuse the same secret token - you'll need to generate it twice. 

```
$ foreman run rake secret
```

Important: Your `APP_NAME` must not have a space in it. Underscores and hypens are accepted.

Your .env file should look something like this:

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
DEVISE_SECRET_KEY=secrettoken
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

Visit your site at: [http://0.0.0.0:5000/](http://0.0.0.0:5000/)


### Deploying to Heroku

1. [Sign up for a Heroku Account](https://www.heroku.com/)
2. [Install the Heroku Toolbelt](https://toolbelt.heroku.com/)

Create a new Heroku app

```
$ heroku create {APP NAME}
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

(Optional) It is highly recommended to install the Papertrail addon to create searchable logs should you run into issues. The "choklad" level is free.

```
$ heroku addons:add papertrail:choklad
```

## Contribute

Looking to help make Crowdtilt Open better?

Our feature development roadmap and bugs are inputted as issues. See a complete list by [clicking here](https://github.com/Crowdtilt/CrowdtiltOpen/issues).

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your code
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new pull request
7. We'll send you a Crowdtilt tshirt

## Contact and License

Want to get in touch? Email [open@crowdtilt.com](mailto:open@crowdtilt.com).

#### MIT License. Copyright 2014 Crowdtilt.
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
