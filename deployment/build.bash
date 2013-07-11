#!/bin/bash -ex
RELEASE=`date +%d%m%y%H%M`
APPID="yamoverflow"
DEPLOY_ROOT="/opt/$APPID"
DEPLOY_TARGET="$DEPLOY_ROOT/$RELEASE"
OWNER="yamoverflow:yamoverflow"
RUBY_VERSION="2.0.0-p247"
RVM="/usr/local/rvm/bin/rvm"
ENVIRONMENT="/usr/local/rvm/environments/ruby-$RUBY_VERSION"

echo "Setting up environment via puppet..."
puppet apply deployment/init.pp --modulepath=deployment/modules --verbose
echo "Setting up ruby version"
( $RVM list rubies|grep $RUBY_VERSION ) || $RVM install $RUBY_VERSION  
source $ENVIRONMENT
( gem list|grep bundler ) || gem install bundler

echo "Packaging release $RELEASE..."
bundle package --all

echo "Copying to $DEPLOY_TARGET..."
mkdir -p  $DEPLOY_TARGET
rsync -a . $DEPLOY_TARGET/
ln -s $ENVIRONMENT $DEPLOY_TARGET/environment
rm  -f $DEPLOY_TARGET/config/database.yml
ln -s /etc/yamoverflow/database.yml $DEPLOY_TARGET/config/database.yml

echo "Fixing permissions..."
chown -R $OWNER $DEPLOY_TARGET
chmod a+rwX $DEPLOY_TARGET/log

echo "Running migrations..."
`cd $DEPLOY_TARGET && rake db:migrate RAILS_ENV=production` 

echo "Switching version..."
rm -f $DEPLOY_ROOT/current
ln -s $DEPLOY_TARGET $DEPLOY_ROOT/current

echo "Restarting yamoverflow..."
restart yamoverflow