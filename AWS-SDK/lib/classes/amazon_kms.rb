require 'aws-sdk-s3'
require 'uuid'
require_relative '../modules/credential'

class AmazonKms
  include Credential

  def initialize(profile,aws_region)
    @cred=get_credential(profile)
    @region=aws_region
    @client = Aws::KMS::Client.new(credentials: @cred,region: @region)
    @resource = Aws::KMS::Resource.new(client: @client)
  end

  def create_kms_key(options = {},key_name)
    resp=@client.create_key(options)
    @client.create_alias({
        alias_name: "alias/#{key_name}",
        target_key_id: "#{resp.key_metadata.key_id}",
        })
  end
end
