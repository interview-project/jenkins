#
# Cookbook:: test_cookbook
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Add Java repository
apt_repository 'java' do
  uri          'ppa:webupd8team/java'
end

# Add Jenkins repository
apt_repository "jenkins" do
  uri "http://pkg.jenkins-ci.org/debian"
  key "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key"
  components ["binary/"]
  distribution ''
  notifies :update, 'apt_update[update]', :immediately
  action :add
end

# Run apt update after Jenkins repository is added
apt_update 'update' do
  action :nothing
end

# Accept Oracle License
execute 'accept-oracle' do
  command 'echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections'
end

# Install Oracle
apt_package 'oracle-java8-installer' do
  notifies :run, 'execute[accept-oracle]', :before
end

# Install Jenkins & HAProxy
apt_package 'jenkins'
apt_package 'haproxy'

# Ensure services started
service 'jenkins' do
  action [:start, :enable]
end

service 'haproxy' do
  action [:start, :enable]
end

# Configure HAProxy to forward requests on port 80 to 8080 (Jenkins)
cookbook_file '/etc/haproxy/haproxy.cfg' do
  notifies :restart, 'service[haproxy]', :immediately
end

# Configure Jenkins to skip the initial admin setup wizard
directory '/var/lib/jenkins/init.groovy.d'
cookbook_file '/var/lib/jenkins/init.groovy.d/skip-initial-setup.groovy' do
  notifies :restart, 'service[jenkins]', :delayed
end

# Disable Security (Would NOT do this in real life, this is only to make demoing easier)
cookbook_file '/var/lib/jenkins/config.xml' do
  notifies :restart, 'service[jenkins]', :delayed
end


