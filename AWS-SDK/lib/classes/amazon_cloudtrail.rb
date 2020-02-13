# require 'aws-sdk-kms'
require_relative '../modules/credential'

class AmazonCloudtrail
  include Credential
  def initialize(profile,aws_region)
    @cred=get_credential(profile)
    @region=aws_region
    @client = Aws::CloudTrail::Client.new(credentials: @cred,region: @region)
    @resource = Aws::CloudTrail::Resource.new(client: @client)
  end

  def create_cloudtrail(options = {})
    puts "Creating Cloudtrail"
    @client.create_trail(options)
  end
end
