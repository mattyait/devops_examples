#!/usr/bin/env ruby
require_relative 'lib/classes/amazon_s3'
require_relative 'lib/classes/amazon_kms'

aws_profile="default"
aws_region="ap-southeast-2"
aws_account_id="948174138596"

#=========Creating S3 Bucket and Attaching a bucket policy========
uuid = UUID.new.generate

bucket_config = {
  bucket: "ruby-sample-#{uuid}",
}
s3=AmazonS3.new(aws_profile,aws_region)
bucket_name=s3.create_bucket(bucket_config)

bucket_policy= {
  bucket: "#{bucket_name}",
  policy: "{\"Version\": \"2012-10-17\", \"Statement\": [{ \"Sid\": \"AWSCloudTrailAclCheck20150319\",\"Effect\": \"Allow\",\"Principal\": {\"Service\": \"cloudtrail.amazonaws.com\"}, \"Action\": [ \"s3:GetBucketAcl\"], \"Resource\": [\"arn:aws:s3:::#{bucket_name}\" ] },{ \"Sid\": \"AWSCloudTrailAclCheck20150319\",\"Effect\": \"Allow\",\"Principal\": {\"Service\": \"cloudtrail.amazonaws.com\"}, \"Action\": [ \"s3:PutObject\"], \"Resource\": [\"arn:aws:s3:::#{bucket_name}/*\" ] } ]}"
}
s3.add_bucket_policy(bucket_policy)
