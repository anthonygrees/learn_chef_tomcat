# # encoding: utf-8

# Inspec test for recipe learn_chef_tomcat::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

#Check that Java is installed
#
describe package 'java-1.7.0-openjdk-devel' do
  it { should be_installed }
end

#
#Check the tomcat user and group
describe group('tomcat') do
  it { should exist }
end

describe user('tomcat' do
  it { should exist }
  it { should belong_to_group 'tomcat'}
end

#Check the tomcat service is enabled and running
#
describe service 'tomcat' do
  it { should be_enabled }
  it { should be_running }
end

#Check that Tomcat is up on localhost
#
describe 'tomcat::default' do
  describe command("curl http://localhost:8080") do
    its(:stdout) { should match /Tomcat/ }
  end
end

#Check the Port 8080
#
describe port 8080 do
  it { should be_listening }
end
