#
# Cookbook:: aws_provisioning
# Recipe:: vpc
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
require 'chef/provisioning/aws_driver'   
with_driver 'aws::us-east-1'             
                                         
aws_vpc 'chef_demo' do                   
  cidr_block '198.0.0.0/24'              
  internet_gateway true                  
  instance_tenancy :default              
  enable_dns_support true                
  enable_dns_hostnames true              
  aws_tags :chef_type => 'aws_vpc'       
end                                      
