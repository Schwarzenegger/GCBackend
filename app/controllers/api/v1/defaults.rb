module API
  module V1
    module Defaults
      extend ActiveSupport::Concern
      included do
        prefix "api"
        version "v1", using: :header, vendor: 'gc_backend'

        default_format :json
        format :json

        formatter :json, Grape::Formatter::FastJsonapi

        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def logger
            Rails.logger
          end

          def authenticate_client!
            error!(I18n.t('api.unauthorized'), 401) unless current_client
          end

          def authenticate_admin!
            begin
              error!(I18n.t('api.unauthorized'), 401) unless current_admin
            rescue
              error!(I18n.t('api.unauthorized'), 401)
            end
          end

          def current_client
            begin
              u = Client.where(access_token: self.headers['Authorization'].partition('=').last).first
              if u
                @current_client = u
              else
                false
              end
            rescue
              false
            end
          end

          def current_admin
            begin
              u = AdminUser.where(access_token: self.headers['Authorization'].partition('=').last).first
              if u
                @current_admin = u
              else
                false
              end
            rescue
              false
            end
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: e.message, status: 422)
        end
      end
    end
  end
end
