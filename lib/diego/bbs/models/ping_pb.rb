# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: ping.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "diego.bbs.models.PingResponse" do
    optional :available, :bool, 1
  end
end

module Diego
  module Bbs
    module Models
      PingResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.PingResponse").msgclass
    end
  end
end