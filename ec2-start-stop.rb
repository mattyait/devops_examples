#!/usr/bin/env ruby
require "aws-sdk"
@aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
@aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
@ec2 = AWS::EC2.new(:access_key_id => @aws_access_key_id,:secret_access_key => @aws_secret_access_key)

action=ARGV[0]

def get_nodeStatus(instance_id)
	begin
		return @ec2.instances[instance_id].status
	rescue
		return "notrpresent"
	end
end

def action_on_instances(instance_id,action)	
	running_state=get_nodeStatus(instance_id)
	puts "Instance is in: #{running_state}"
	if action == "start" and "#{running_state}" == "stopped" || "#{running_state}" == "notrunning"
			begin
				@ec2.instances[instance_id].start	
				puts "Starting the instance: #{instance_id}"
			rescue Exception => e
				puts e
			end		
	elsif action == "stop" and "#{running_state}" == "running" || "#{running_state}" == "pending"	
		begin
			@ec2.instances[instance_id].stop
			puts "Stopping the instance: #{instance_id}"
		rescue Exception => e
			puts e
		end				
	end
end

puts "Required Action: #{action}"
puts "Performing action: #{action} on instance: #{id}"
action_on_instances(instance_id,action)



