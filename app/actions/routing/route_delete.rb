module VCAP::CloudController
  class RouteDelete
    class ServiceInstanceAssociationError < StandardError; end

    def initialize(app_event_repository:, route_event_repository:, user_audit_info:)
      @app_event_repository   = app_event_repository
      @route_event_repository = route_event_repository
      @user_audit_info        = user_audit_info
    end

    def delete_sync(route:, recursive:)
      deletion_job = do_delete(recursive, route)
      deletion_job.perform
    end

    def delete_async(route:, recursive:)
      deletion_job = do_delete(recursive, route)
      Jobs::Enqueuer.new(deletion_job, queue: 'cc-generic').enqueue
    end

    def atomic_delete(route:)
      delete_count = Route.where(guid: route.guid).
                     exclude(guid: RouteMappingModel.where(route_guid: route.guid).select(:route_guid)).
                     exclude(id: RouteBinding.where(route_id: route.id).select(:route_id)).
                     delete
      if delete_count > 0
        route_event_repository.record_route_delete_request(route, user_audit_info, false)
      end
    end

    private

    def do_delete(recursive, route)
      if !recursive && route.service_instance.present?
        raise ServiceInstanceAssociationError.new
      end

      route_event_repository.record_route_delete_request(route, user_audit_info, recursive)

      route.route_mappings.each do |route_mapping|
        app_event_repository.record_unmap_route(
          route_mapping.app,
          route,
          user_audit_info,
          route_mapping: route_mapping
        )
      end

      Jobs::Runtime::ModelDeletion.new(route.class, route.guid)
    end

    attr_reader :route_event_repository, :app_event_repository, :user_audit_info
  end
end
