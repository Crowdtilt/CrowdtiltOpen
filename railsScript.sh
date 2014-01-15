#!/bin/bash
{
clear
echo "This script requires superuser access to install apt packages."
echo "You will be prompted for your password by sudo."

# clear any previous sudo permission
sudo -k
# run inside sudo
sudo bash <<SCRIPT

echo "----------   Updating Sources List --------------"
sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
apt-get update
echo "----------   Installing Curl --------------"
apt-get install curl
echo "----------   Installing RVM --------------"
\curl -sSL https://get.rvm.io | bash
echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc
source /etc/profile.d/rvm.sh
echo "----------   Setting RVM Requirements --------------"
rvm requirements
echo "----------   Setting RVM Installing Ruby 1.9.3 --------------"
rvm install 1.9.3
rvm use 1.9.3 --default
apt-get install libyaml-dev
gem update
echo "----------   Setting RVM Installing Rails --------------"
gem install --no-rdoc --no-ri rails
echo "----------   Installing Depend. & Imagemagick --------------"
apt-get -y install libxslt-dev libxml2-dev libsqlite3-dev
apt-get -y install imagemagick
echo "----------   Installing Heroku --------------"
echo "deb https://toolbelt.heroku.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list
wget -O- https://toolbelt.heroku.com/apt/release.key | apt-key add -
apt-get update
apt-get -y install heroku-toolbelt
echo "----------   Installing Node JS --------------"
apt-get -y install  python-software-properties python g++ make
add-apt-repository ppa:chris-lea/node.js
apt-get update
apt-get -y install nodejs
echo "----------   Installing GIT --------------"
apt-get -y install git-core
echo "----------   Installing Postgresql --------------"
apt-get -y install postgresql postgresql-contrib
apt-get -y install libpq-dev
rvmsudo gem install pg -v '0.17.1' -- --with-pg-lib=/usr/include/postgresql

echo "----------   Getting Repository --------------"
mkdir GIT
cd GIT
git clone https://github.com/Crowdtilt/Crowdhoster.git
echo "----------   Updating With Bundle --------------"
cd Crowdhoster
cp .env.example .env
bundle install 

echo "Rails Script Completed - Enjoy !!"
SCRIPT
}
