require 'aws-sdk'
require 'uuid'
require_relative '../modules/credential'

class AmazonS3
  include Credential

  def initialize(profile,aws_region)
    @cred=get_credential(profile)
    @region=aws_region
    @sclient = Aws::S3::Client.new(credentials: @cred,region: @region)
    @resource = Aws::S3::Resource.new(client: @sclient)
  end

  def create_bucket(options = {})
      resp = @resource.create_bucket(options)
      puts resp.name
      return resp.name

  end

  def add_bucket_policy(options = {})
    resp = @sclient.put_bucket_policy(options)
  end

  def get_list_buckets()
    resp = @sclient.list_buckets()
    return resp
  end

end
