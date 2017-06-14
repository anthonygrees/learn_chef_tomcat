#
# Cookbook Name:: learn_chef_tomcat
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

#
#Install java on Centos
yum_package 'java-1.7.0-openjdk-devel' do
  action :install # Install is default and does not need to be specified
end
