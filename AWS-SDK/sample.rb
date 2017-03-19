#!/usr/bin/env ruby
require_relative 'lib/credential/credential'
require_relative 'lib/ec2/ec2_instance'

include Credential
include Ec2Instance

cred = get_credential('firstfuel')
ids=instance_id(cred,"us-east-1","Name","qaperf-*")
ids.each do |i|
  puts i
end
