#!/usr/bin/env ruby
require_relative 'lib/credential/credential'
require_relative 'lib/ec2/ec2_instance'

include Credential
include Ec2Instance

cred = get_credential('profile')
ids=instance_id(cred,"us-east-1","Name","qa-*")
ids.each do |i|
  puts i
end
