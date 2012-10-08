#http://chrisadams.me.uk/2010/05/10/setting-up-a-centos-base-box-for-development-and-testing-with-vagrant/
#kernel source is needed for vbox additions

date > /etc/vsphere_box_build_time


yum -y install gcc bzip2 make kernel-devel-`uname -r`
#yum -y update
#yum -y upgrade

yum -y install gcc-c++ zlib-devel openssl-devel readline-devel sqlite3-devel
yum -y erase wireless-tools gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all

#Installing ruby
cd /tmp
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz || fail "Could not download Ruby source"
tar xzvf ruby-1.9.2-p180.tar.gz 
cd ruby-1.9.2-p180
./configure
make && make install
cd /tmp
rm -rf /tmp/ruby-1.9.2-p180
rm /tmp/ruby-1.9.2-p180.tar.gz
ln -s /usr/local/bin/ruby /usr/bin/ruby # Create a sym link for the same path
ln -s /usr/local/bin/gem /usr/bin/gem # Create a sym link for the same path

#Installing chef & Puppet
/usr/bin/gem install chef --no-ri --no-rdoc
/usr/bin/gem install puppet --no-ri --no-rdoc

#Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chown -R vagrant /home/vagrant/.ssh

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed -i "s/^\(.*env_keep = \"\)/\1PATH /" /etc/sudoers

#poweroff -h

exit
