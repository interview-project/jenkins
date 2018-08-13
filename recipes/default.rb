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

# Create init.groovy.d directory
directory '/var/lib/jenkins/init.groovy.d'

# Add Init Scripts
remote_directory '/var/lib/jenkins/init.groovy.d/' do
  source 'init-scripts'
  owner 'jenkins'
  group 'jenkins'
  mode '0755'
  files_owner 'jenkins'
  files_group 'jenkins'
  files_mode '0755'
  action :create
end

# Add some much-needed plugins
remote_directory '/var/lib/jenkins/plugins' do
  source 'plugins'
  owner 'jenkins'
  group 'jenkins'
  mode '0755'
  files_owner 'jenkins'
  files_group 'jenkins'
  files_mode '0755'
  action :create
end

# Add interview-project Github org.
remote_directory '/var/lib/jenkins/jobs' do
  source 'jobs'
  owner 'jenkins'
  group 'jenkins'
  mode '0755'
  files_owner 'jenkins'
  files_group 'jenkins'
  files_mode '0755'
  action :create
end


# Configure HAProxy to forward requests on port 80 to 8080 (Jenkins)
cookbook_file '/etc/haproxy/haproxy.cfg' do
  notifies :restart, 'service[haproxy]', :immediately
end

# Disable Security (Would NOT do this in real life, this is only to make demoing easier)
cookbook_file '/var/lib/jenkins/config.xml' do
  notifies :restart, 'service[jenkins]', :delayed
end

# Ensure services started
service 'jenkins' do
  action [:start, :enable]
end

# Start HAProxy
service 'haproxy' do
  action [:start, :enable]
end

