#!/bin/bash
{
clear
echo "This script requires superuser access to install apt packages."
echo "You will be prompted for your password by sudo."
CrowdHoster_CUser=$USER
CrowdHoster_PWD=$(pwd)
echo "switching from $CrowdHoster_CUser to root"
# clear any previous sudo permission
sudo -k
# run inside sudo
sudo bash <<SCRIPT
echo "----------   Updating Sources List --------------"
sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
apt-get update
echo "----------   Installing Curl --------------"
apt-get -y install curl
echo "----------   Installing RVM --------------"
\curl -sSL https://get.rvm.io | bash
echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc
source /etc/profile.d/rvm.sh
echo "----------   Setting RVM Requirements --------------"
rvm requirements
echo "----------   Setting RVM Installing Ruby 1.9.3 --------------"
rvm install 1.9.3
rvm use 1.9.3 --default
apt-get -y install libyaml-dev
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
cd $CrowdHoster_PWD
mkdir -m 777 GIT
cd GIT
git clone https://github.com/Crowdtilt/Crowdhoster.git
source /etc/profile.d/rvm.sh
echo "----------   Updating With Bundle --------------"
chmod 777 Crowdhoster
cd Crowdhoster
cp .env.example .env
bundle install 
echo "------------ Database Configuration Started ----------"
wget -O /etc/postgresql/9.1/main/pg_hba.conf https://raw2.github.com/rmostafa/Crowdhoster/master/pg_hba.conf
/etc/init.d/postgresql restart
sudo -u postgres createuser --superuser $USER
sudo -u postgres createuser --superuser $CrowdHoster_CUser
SCRIPT
cd $CrowdHoster_PWD
echo "------------ Script Completed ----------"
echo "Installation of Rails and CrowdHoster Configuration is Completed  !!"
echo "------------ THANKS : CrowdHoster team ----------"
}
