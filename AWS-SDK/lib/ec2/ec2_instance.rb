#!/usr/bin/env ruby
# Module related to Ec2 Instances
module Ec2Instance
  def instanceid_fromtag; end

  def instance_ids(credentials, region, tag_type, tag_value)
    array = []
    ec2 = Aws::EC2::Resource.new(credentials: credentials, region: region)
    ec2.instances(filters: [{ name: "tag:#{tag_type}", values: [tag_value.to_s] }]).each do |i|
      array.push(i.id)
    end
    return array
  end

  def create_ec2_instance; end
end
