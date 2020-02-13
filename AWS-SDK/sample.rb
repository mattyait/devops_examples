#!/usr/bin/env ruby
require_relative 'lib/classes/amazon_s3'
require_relative 'lib/classes/amazon_kms'

aws_profile="default"
aws_region="ap-southeast-2"

# cred = get_credential(aws_profile)
# ids=instance_id(cred,"us-east-1","Name","qa-*")
# ids.each do |i|
  # puts i
# end

#=========Creating S3 Bucket and Attaching a bucket policy========
uuid = UUID.new
bucket_config = {
  bucket: "ruby-sample-#{uuid.generate}",
}
s3=AmazonS3.new(aws_profile,aws_region)
bucket_name=s3.create_bucket(bucket_config)

bucket_policy= {
  bucket: "#{bucket_name}",
  policy: "{\"Version\": \"2012-10-17\", \"Statement\": [{ \"Sid\": \"AWSCloudTrailAclCheck20150319\",\"Effect\": \"Allow\",\"Principal\": {\"Service\": \"cloudtrail.amazonaws.com\"}, \"Action\": [ \"s3:GetBucketAcl\"], \"Resource\": [\"arn:aws:s3:::#{bucket_name}\" ] },{ \"Sid\": \"AWSCloudTrailAclCheck20150319\",\"Effect\": \"Allow\",\"Principal\": {\"Service\": \"cloudtrail.amazonaws.com\"}, \"Action\": [ \"s3:PutObject\"], \"Resource\": [\"arn:aws:s3:::#{bucket_name}/*\" ] } ]}"
}
s3.add_bucket_policy(bucket_policy)

#=======Creating a custom KMS=======
kms_config={
  description: "Customer Key for cloudtrail",
  customer_master_key_spec: "SYMMETRIC_DEFAULT", # accepts RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, ECC_SECG_P256K1, SYMMETRIC_DEFAULT
  origin: "AWS_KMS", # accepts AWS_KMS, EXTERNAL, AWS_CLOUDHSM
  tags: [
    {
      tag_key: "Purpose",
      tag_value: "Cloudtrail",
    },
  ],
}
kms=AmazonKms.new(aws_profile,aws_region)
kms.create_kms_key(kms_config,"demo")
