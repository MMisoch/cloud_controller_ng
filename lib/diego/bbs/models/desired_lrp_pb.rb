# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: desired_lrp.proto

require 'google/protobuf'

require 'actions_pb'
require 'cached_dependency_pb'
require 'certificate_properties_pb'
require 'environment_variables_pb'
require 'modification_tag_pb'
require 'network_pb'
require 'security_group_pb'
require 'volume_mount_pb'
require 'check_definition_pb'
require 'image_layer_pb'
require 'metric_tags_pb'
require 'sidecar_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "diego.bbs.models.DesiredLRPSchedulingInfo" do
    optional :desired_lrp_key, :message, 1, "diego.bbs.models.DesiredLRPKey"
    optional :annotation, :string, 2
    optional :instances, :int32, 3
    optional :desired_lrp_resource, :message, 4, "diego.bbs.models.DesiredLRPResource"
    optional :routes, :message, 5, "diego.bbs.models.ProtoRoutes"
    optional :modification_tag, :message, 6, "diego.bbs.models.ModificationTag"
    optional :volume_placement, :message, 7, "diego.bbs.models.VolumePlacement"
    repeated :PlacementTags, :string, 8
  end
  add_message "diego.bbs.models.DesiredLRPRunInfo" do
    optional :desired_lrp_key, :message, 1, "diego.bbs.models.DesiredLRPKey"
    repeated :environment_variables, :message, 2, "diego.bbs.models.EnvironmentVariable"
    optional :setup, :message, 3, "diego.bbs.models.Action"
    optional :action, :message, 4, "diego.bbs.models.Action"
    optional :monitor, :message, 5, "diego.bbs.models.Action"
    optional :deprecated_start_timeout_s, :uint32, 6
    optional :privileged, :bool, 7
    optional :cpu_weight, :uint32, 8
    repeated :ports, :uint32, 9
    repeated :egress_rules, :message, 10, "diego.bbs.models.SecurityGroupRule"
    optional :log_source, :string, 11
    optional :metrics_guid, :string, 12
    optional :created_at, :int64, 13
    repeated :cached_dependencies, :message, 14, "diego.bbs.models.CachedDependency"
    optional :legacy_download_user, :string, 15
    optional :trusted_system_certificates_path, :string, 16
    repeated :volume_mounts, :message, 17, "diego.bbs.models.VolumeMount"
    optional :network, :message, 18, "diego.bbs.models.Network"
    optional :start_timeout_ms, :int64, 19
    optional :certificate_properties, :message, 20, "diego.bbs.models.CertificateProperties"
    optional :image_username, :string, 21
    optional :image_password, :string, 22
    optional :check_definition, :message, 23, "diego.bbs.models.CheckDefinition"
    repeated :image_layers, :message, 24, "diego.bbs.models.ImageLayer"
    map :metric_tags, :string, :message, 25, "diego.bbs.models.MetricTagValue"
    repeated :sidecars, :message, 26, "diego.bbs.models.Sidecar"
  end
  add_message "diego.bbs.models.ProtoRoutes" do
    map :routes, :string, :bytes, 1
  end
  add_message "diego.bbs.models.DesiredLRPUpdate" do
    optional :routes, :message, 2, "diego.bbs.models.ProtoRoutes"
    oneof :optional_instances do
      optional :instances, :int32, 1
    end
    oneof :optional_annotation do
      optional :annotation, :string, 3
    end
  end
  add_message "diego.bbs.models.DesiredLRPKey" do
    optional :process_guid, :string, 1
    optional :domain, :string, 2
    optional :log_guid, :string, 3
  end
  add_message "diego.bbs.models.DesiredLRPResource" do
    optional :memory_mb, :int32, 1
    optional :disk_mb, :int32, 2
    optional :root_fs, :string, 3
    optional :max_pids, :int32, 4
  end
  add_message "diego.bbs.models.DesiredLRP" do
    optional :process_guid, :string, 1
    optional :domain, :string, 2
    optional :root_fs, :string, 3
    optional :instances, :int32, 4
    repeated :environment_variables, :message, 5, "diego.bbs.models.EnvironmentVariable"
    optional :setup, :message, 6, "diego.bbs.models.Action"
    optional :action, :message, 7, "diego.bbs.models.Action"
    optional :start_timeout_ms, :int64, 27
    optional :deprecated_start_timeout_s, :uint32, 8
    optional :monitor, :message, 9, "diego.bbs.models.Action"
    optional :disk_mb, :int32, 10
    optional :memory_mb, :int32, 11
    optional :cpu_weight, :uint32, 12
    optional :privileged, :bool, 13
    repeated :ports, :uint32, 14
    optional :routes, :message, 15, "diego.bbs.models.ProtoRoutes"
    optional :log_source, :string, 16
    optional :log_guid, :string, 17
    optional :metrics_guid, :string, 18
    optional :annotation, :string, 19
    repeated :egress_rules, :message, 20, "diego.bbs.models.SecurityGroupRule"
    optional :modification_tag, :message, 21, "diego.bbs.models.ModificationTag"
    repeated :cached_dependencies, :message, 22, "diego.bbs.models.CachedDependency"
    optional :legacy_download_user, :string, 23
    optional :trusted_system_certificates_path, :string, 24
    repeated :volume_mounts, :message, 25, "diego.bbs.models.VolumeMount"
    optional :network, :message, 26, "diego.bbs.models.Network"
    repeated :PlacementTags, :string, 28
    optional :max_pids, :int32, 29
    optional :certificate_properties, :message, 30, "diego.bbs.models.CertificateProperties"
    optional :image_username, :string, 31
    optional :image_password, :string, 32
    optional :check_definition, :message, 33, "diego.bbs.models.CheckDefinition"
    repeated :image_layers, :message, 34, "diego.bbs.models.ImageLayer"
    map :metric_tags, :string, :message, 35, "diego.bbs.models.MetricTagValue"
    repeated :sidecars, :message, 36, "diego.bbs.models.Sidecar"
  end
end

module Diego
  module Bbs
    module Models
      DesiredLRPSchedulingInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.DesiredLRPSchedulingInfo").msgclass
      DesiredLRPRunInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.DesiredLRPRunInfo").msgclass
      ProtoRoutes = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.ProtoRoutes").msgclass
      DesiredLRPUpdate = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.DesiredLRPUpdate").msgclass
      DesiredLRPKey = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.DesiredLRPKey").msgclass
      DesiredLRPResource = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.DesiredLRPResource").msgclass
      DesiredLRP = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.DesiredLRP").msgclass
    end
  end
end
