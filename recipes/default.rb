#
# Cookbook Name:: learn_chef_tomcat
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

#
#Install java on Centos
yum_package 'java-1.7.0-openjdk-devel' do
  action :install # Install is default and does not need to be specified end group 'chef' group 'tomcat'
#
#Create group and user Chef
group 'chef' 

user 'chef' do
  group 'chef'
  system true
  shell '/bin/bash'
end
#
#Get the apache tomcat tar and put it in the tmp dir
#
remote_file '/tmp/apache-tomcat-8.5.15.tar.gz' do
  source 'http://apache.uberglobalmirror.com/tomcat/tomcat-8/v8.5.15/bin/apache-tomcat-8.5.15.tar.gz'
  owner 'chef'
  group 'chef'
  mode '0755'
  action :create
end
#
#Create the tomcat directory
#
directory "/opt/tomcat" do
  group 'tomcat' 
end 
#
# Extract the tomcat tar
#
bash 'extract_module' do
  cwd '/tmp'
  code <<-EOH
#    mkdir -p /opt/tomcat
    tar xvf apache-tomcat-8.5.15.tar.gz -C /opt/tomcat --strip-components=1
  EOH
end

directory '/opt/tomcat/conf' do 
  mode '0070'
end

execute 'chmod g+r conf/*'
execute 'chown -R tomcat webapps/ work/ temp/ logs/'

template '/etc/systemd/system/tomcat.service' do # ~FC033
  source 'tomcat.service.erb'
  mode '0644'
  owner 'tomcat'
  group 'tomcat'
end

execute 'systemctl daemon-reload'

service "tomcat" do
  action [ :start, :enable ]
end
