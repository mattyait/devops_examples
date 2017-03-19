#!/usr/bin/env ruby
require 'aws-sdk'
# Module related to Credential to access AWS
module Credential
  def get_credential(profile = nil)
    return nil if profile.nil?
    begin
      cred = Aws::SharedCredentials.new(profile_name: profile)
    rescue Exception => e
      puts "\e[31mERROR: #{e.message}\e[0m"
      exit 1
    end
    return cred if cred.loadable?
    puts "\e[31mERROR: Credentials are not loadable. Make sure you have ~/.aws configured correctly.\e[0m"
    return nil
  end
end
