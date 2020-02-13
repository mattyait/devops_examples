#!/usr/bin/env ruby
require_relative 'lib/classes/amazon_s3'
require_relative 'lib/classes/amazon_kms'
require_relative 'lib/classes/amazon_cloudtrail'
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
kmsmetadata_resp=kms.create_kms_key(kms_config,"demo-#{uuid.generate}")

kmskey_policy={
  "Sid": "Allow CloudTrail to encrypt logs",
  "Effect": "Allow",
  "Principal": {
    "Service": "cloudtrail.amazonaws.com"
  },
  "Action": "kms:GenerateDataKey*",
  "Resource": "*",
  "Condition": {
    "StringLike": {
      "kms:EncryptionContext:aws:cloudtrail:arn": [
        "arn:aws:cloudtrail:*:#{kmsmetadata_resp.aws_account_id}:trail/*"
      ]
    }
  }
}.to_json

puts kmskey_policy

kms.attach_policy(kmskey_policy,kmsmetadata_resp.key_id,"kms_policy_cloudtrail")

#========Creating a Cloudtrail and enable it for security====
cloudtrail_config={
  name: "demo-#{uuid.generate}", # required
  s3_bucket_name: "#{bucket_name}",
  include_global_service_events: true,
  is_multi_region_trail: true,
  enable_log_file_validation: true,
  kms_key_id: "#{kmsmetadata_resp.key_id}",
  is_organization_trail: true,
  tags_list: [
    {
      key: "Purpose", # required
      value: "Cloudtrail",
    },
  ],
}
ct=AmazonCloudtrail.new(aws_profile,aws_region)
ct.create_cloudtrail(cloudtrail_config)
