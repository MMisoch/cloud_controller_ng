require 'spec_helper'
require 'presenters/v3/service_plan_presenter'

RSpec.describe VCAP::CloudController::Presenters::V3::ServicePlanPresenter do
  let(:guid) { service_plan.guid }
  let(:maintenance_info) do
    {
    version: '1.0.0',
      description: 'best plan ever'
  }
  end
  let(:service_plan) do
    VCAP::CloudController::ServicePlan.make(maintenance_info: maintenance_info)
  end

  let!(:potato_label) do
    VCAP::CloudController::ServicePlanLabelModel.make(
      key_prefix: 'canberra.au',
      key_name: 'potato',
      value: 'mashed',
      resource_guid: service_plan.guid
    )
  end

  let!(:mountain_annotation) do
    VCAP::CloudController::ServicePlanAnnotationModel.make(
      key: 'altitude',
      value: '14,412',
      resource_guid: service_plan.guid,
    )
  end

  describe '#to_hash' do
    let(:result) { described_class.new(service_plan).to_hash.deep_symbolize_keys }

    it 'presents the service plan' do
      expect(result).to eq({
        guid: guid,
        created_at: service_plan.created_at,
        updated_at: service_plan.updated_at,
        visibility_type: 'public',
        available: true,
        name: service_plan.name,
        free: false,
        description: service_plan.description,
        maintenance_info: {
          version: '1.0.0',
          description: 'best plan ever'
        },
        broker_catalog: {
          metadata: {},
          id: service_plan.unique_id,
          maximum_polling_duration: nil,
          features: {
            bindable: true,
            plan_updateable: false
          }
        },
        schemas: {
          service_instance: {
            create: {},
            update: {}
          },
          service_binding: {
            create: {}
          }
        },
        metadata: {
          labels: {
            'canberra.au/potato': 'mashed'
          },
          annotations: {
            altitude: '14,412'
          }
        },
        relationships: {
          service_offering: {
            data: {
              guid: service_plan.service.guid
            }
          }
        },
        links: {
          self: {
            href: "#{link_prefix}/v3/service_plans/#{guid}"
          },
          service_offering: {
            href: "#{link_prefix}/v3/service_offerings/#{service_plan.service.guid}"
          },
          visibility: {
            href: "#{link_prefix}/v3/service_plans/#{service_plan.guid}/visibility"
          }
        }
      })
    end

    context 'when `active` is false' do
      let(:service_plan) do
        VCAP::CloudController::ServicePlan.make(active: false)
      end

      it 'presents the service plan with available false' do
        expect(result[:available]).to eq(false)
      end
    end

    context 'when `free` is false' do
      let(:service_plan) do
        VCAP::CloudController::ServicePlan.make(free: false)
      end

      it 'presents the service plan with free false' do
        expect(result[:free]).to eq(false)
      end
    end

    context 'when plan has `maximum_polling_duration`' do
      let(:service_plan) do
        VCAP::CloudController::ServicePlan.make(maximum_polling_duration: 60)
      end

      it 'presents the service plan with maximum_polling_duration' do
        expect(result[:broker_catalog][:maximum_polling_duration]).to eq(60)
      end
    end

    context 'when `bindable` is false' do
      let(:service_plan) do
        VCAP::CloudController::ServicePlan.make(bindable: false)
      end

      it 'presents the service plan with bindable false' do
        expect(result[:broker_catalog][:features][:bindable]).to eq(false)
      end
    end

    context 'when `plan_updateable` is false' do
      let(:service_plan) do
        VCAP::CloudController::ServicePlan.make(plan_updateable: false)
      end

      it 'presents the service plan with plan_updateable false' do
        expect(result[:broker_catalog][:features][:plan_updateable]).to eq(false)
      end
    end

    context 'when plan has `extra`' do
      let(:service_plan) do
        VCAP::CloudController::ServicePlan.make(extra: '{"some_key": "some-value"}')
      end

      it 'presents the service plan with metadata' do
        expect(result[:broker_catalog][:metadata][:some_key]).to eq('some-value')
      end
    end

    context 'when plan has no `maintenance_info`' do
      let(:service_plan) do
        VCAP::CloudController::ServicePlan.make
      end

      it 'presents the service plan with empty maintenance_info' do
        expect(result[:maintenance_info]).to be_empty
      end
    end

    context 'schemas' do
      let(:schema) {
        '{
            "$schema": "http://json-schema.org/draft-04/schema#",
            "type": "object",
            "properties": {
              "billing-account": {
                "description": "Billing account number used to charge use of shared fake server.",
                "type": "string"
              }
            }
          }'
      }

      let(:parsed_schema) { JSON.parse(schema).deep_symbolize_keys }

      context 'when plan has create service_instance schema' do
        let(:service_plan) do
          VCAP::CloudController::ServicePlan.make(create_instance_schema: schema)
        end

        it 'presents the service plan create service_instance with the schema' do
          expect(result[:schemas][:service_instance][:create][:parameters]).to eq(parsed_schema)
          expect(result[:schemas][:service_instance][:update]).to be_empty
          expect(result[:schemas][:service_binding][:create]).to be_empty
        end
      end

      context 'when plan has update service_instance schema' do
        let(:service_plan) do
          VCAP::CloudController::ServicePlan.make(update_instance_schema: schema)
        end

        it 'presents the service plan update service_instance with the schema' do
          expect(result[:schemas][:service_instance][:update][:parameters]).to eq(parsed_schema)
          expect(result[:schemas][:service_instance][:create]).to be_empty
          expect(result[:schemas][:service_binding][:create]).to be_empty
        end
      end

      context 'when plan has create service_binding schema' do
        let(:service_plan) do
          VCAP::CloudController::ServicePlan.make(create_binding_schema: schema)
        end

        it 'presents the service plan update service_instance with the schema' do
          expect(result[:schemas][:service_instance][:update]).to be_empty
          expect(result[:schemas][:service_instance][:create]).to be_empty
          expect(result[:schemas][:service_binding][:create][:parameters]).to eq(parsed_schema)
        end
      end
    end

    context 'when service plan is from a space-scoped broker' do
      let(:space) { VCAP::CloudController::Space.make }
      let(:service_broker) { VCAP::CloudController::ServiceBroker.make(space: space) }
      let(:service_offering) { VCAP::CloudController::Service.make(service_broker: service_broker) }
      let(:service_plan) { VCAP::CloudController::ServicePlan.make(service: service_offering) }

      it 'includes a space relationship and link' do
        expect(result).to include({
          relationships: include({
            space: { data: { guid: space.guid } }
          }),
          links: include({
            space: { href: "#{link_prefix}/v3/spaces/#{space.guid}" }
          })
        })
      end
    end
  end
end
