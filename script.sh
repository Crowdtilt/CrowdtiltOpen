# postinstall.sh created from Mitchell's official lucid32/64 baseboxes

date > /etc/vagrant_box_build_time

# Apt-install various things necessary for Ruby, guest additions,
# etc., and remove optional things to trim down the machine.
apt-get -y update
apt-get -y upgrade
apt-get -y -f install
apt-get -y install curl
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline5-dev
apt-get -y install git-core vim

# Setup sudo to allow no-password sudo for "admin"
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Install NFS client
apt-get -y install nfs-common

# Install Foreman
/opt/ruby/bin/gem install foreman --no-ri --no-rdoc

# Install PostgreSQL 9.2.4
wget http://ftp.postgresql.org/pub/source/v9.2.4/postgresql-9.2.4.tar.bz2
tar jxf postgresql-9.2.4.tar.bz2
cd postgresql-9.2.4
./configure --prefix=/usr
make world
make install
cd ..
rm -rf postgresql-9.2.4*

# Initialize postgres DB
useradd -p postgres postgres
mkdir -p /var/pgsql/data
chown postgres /var/pgsql/data
su -c "/usr/bin/initdb -D /var/pgsql/data --locale=en_US.UTF-8 --encoding=UNICODE" postgres
mkdir /var/pgsql/data/log
chown postgres /var/pgsql/data/log

# Start postgres
su -c '/usr/bin/pg_ctl start -l /var/pgsql/data/log/logfile -D /var/pgsql/data' postgres

# Start postgres at boot
sed -i -e 's/exit 0//g' /etc/rc.local
echo "su -c '/usr/bin/pg_ctl start -l /var/pgsql/data/log/logfile -D /var/pgsql/data' postgres" >> /etc/rc.local

# Add /opt/ruby/bin to the global path as the last resort so
# Ruby, RubyGems, and Chef/Puppet are visible
echo 'PATH=$PATH:/opt/ruby/bin' > /etc/profile.d/vagrantruby.sh

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp3/*

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

# Install Heroku toolbelt
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Install some libraries
apt-get -y install libxml2-dev libxslt-dev curl libcurl4-openssl-dev
apt-get -y install imagemagick libmagickcore-dev libmagickwand-dev
apt-get clean

# Set locale
echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

# Add 'vagrant' role
su -c 'createuser vagrant -s' postgres

# Install RVM, ruby 1.9.3, and the Rails gem
echo 'Adding RVM, ruby, and the Rails gem'
\curl -L https://get.rvm.io | bash -s stable --rails --ruby=1.9.3

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces
exit
exit

#Manual commands to run on start
#cd /vagrant
#sudo rvm install ruby-1.9.3-p448
#source /usr/local/rvm/scripts/rvm
#rvm use 1.9.3 --default
#bundle install
#foreman run rake db:create
#foreman run rake db:migrate
#foreman start