# Tilt Open

Launch your own advanced crowdfunding page.

---

## Please Note

The open source version of Tilt Open contained in this repo is no longer in active development and we are no longer issuing Sandbox API credentials.

Please visit [tilt.com/pro](https://tilt.com/pro) to see the newest features we've added to the hosted version.

## Install

### Dependencies
To run Tilt Open you'll need the following prerequisites installed:

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
$ curl -L https://get.rvm.io | bash -s stable --rails --ruby=1.9.3
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

### Local Setup

Get  started by:

* Downloading a .zip of the [latest release](https://github.com/Crowdtilt/CrowdtiltOpen/releases) to your local machine

  or

* Creating a fork of Tilt Open and cloning it to your local machine.



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

## Contact and License

Want to get in touch? Email [questions@tilt.com](mailto:questions@tilt.com).

#### MIT License. Copyright 2014 Tilt.com.
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
Brought to you by the team at [Tilt](http://tilt.com) // Group fund anything
