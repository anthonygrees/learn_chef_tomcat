#
# Cookbook Name:: learn_chef_tomcat
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

#
#Install java on Centos
package 'java-1.7.0-openjdk-devel'
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
  mode '774'
  action :create
end
#
#execute 'groupadd tomcat'
#execute 'useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat'

group 'tomcat'

user 'tomcat' do
  group 'tomcat'
  system true
  shell '/bin/bash'
end

#
#Create the tomcat directory
#
#execute 'mkdir /opt/tomcat'

directory "/opt/tomcat" do
  group 'tomcat' 
  mode '774'
end 
#
# Extract the tomcat tar
#
bash 'extract_module' do
  cwd '/tmp'
  code <<-EOH
    tar xvf apache-tomcat-8.5.15.tar.gz -C /opt/tomcat --strip-components=1
  EOH
  not_if { ::File.exist?('/opt/tomcat/RUNNING.txt') }  ## Example Guard
end

#execute 'chgrp -R tomcat /opt/tomcat/conf'

directory '/opt/tomcat/conf' do 
  mode '774'
end

execute 'chmod g+r /opt/tomcat/conf/*'
execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'

template '/etc/systemd/system/tomcat.service' do # ~FC033
  source 'tomcat.service.erb'
  mode '774'
  owner 'tomcat'
  group 'tomcat'
end

execute 'systemctl daemon-reload'

service "tomcat" do
  action [ :start, :enable ]
end
