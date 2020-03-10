module Kpack
  class Stager
    APP_GUID_LABEL_KEY = 'cloudfoundry.org/app_guid'.freeze
    BUILD_GUID_LABEL_KEY = 'cloudfoundry.org/build_guid'.freeze

    def initialize(builder_namespace:, registry_service_account_name:, registry_tag_base:)
      @builder_namespace = builder_namespace
      @registry_service_account_name = registry_service_account_name
      @registry_tag_base = registry_tag_base
    end

    def stage(staging_details)
      client.create_image(image_resource(staging_details))
    end

    def stop_stage
      raise NoMethodError
    end

    def staging_complete
      raise NoMethodError
    end

    private

    attr_reader :builder_namespace, :registry_service_account_name, :registry_tag_base

    def image_resource(staging_details)
      Kubeclient::Resource.new({
        metadata: {
          name: staging_details.package.guid,
          namespace: builder_namespace,
          labels: {
            APP_GUID_LABEL_KEY.to_sym =>  staging_details.package.app.guid,
            BUILD_GUID_LABEL_KEY.to_sym =>  staging_details.staging_guid
          },
          annotations: {
            'sidecar.istio.io/inject' => 'false'
          },
        },
        spec: {
          serviceAccount: registry_service_account_name,
          builder: {
            name: 'cf-autodetect-builder',
            kind: 'ClusterBuilder'
          },
          tag: "#{registry_tag_base}/#{staging_details.package.guid}",
          source: {
            blob: {
              url: blobstore_url_generator.package_download_url(staging_details.package),
            }
          }
        }
      })
    end

    def client
      ::CloudController::DependencyLocator.instance.kpack_client
    end

    def blobstore_url_generator
      ::CloudController::DependencyLocator.instance.blobstore_url_generator
    end
  end
end
