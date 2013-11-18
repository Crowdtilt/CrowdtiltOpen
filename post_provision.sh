#Manual commands to run on start
cd /vagrant
sudo rvm install ruby-1.9.3-p448
source /usr/local/rvm/scripts/rvm
rvm use 1.9.3 --default
bundle install
foreman run rake db:setup
#foreman start