# # encoding: utf-8

# Inspec test for recipe learn_chef_tomcat::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

#Check that Java is installed
#
describe package 'java-1.7.0-openjdk-devel' do
  it { should be_installed }
end
