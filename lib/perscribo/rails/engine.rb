require 'perscribo/support/core/logging'

module Perscribo
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Perscribo

      EndpointLogger = Support::Core::Logging::EndpointLogger
      SingletonLogger = Support::Core::Logging::SingletonLogger

      config.before_initialize do
        unless ::Perscribo::Rails.const_defined?(:APP_ROOT, false)
          ::Perscribo::Rails.const_set(:APP_ROOT, ::Rails.root)
        end

        output_dir = "#{::Perscribo::Rails::APP_ROOT}/tmp"

        ::Rails.logger = EndpointLogger.new(::Rails.logger)
        ::ActionController::Base.logger = EndpointLogger.new(::ActionController::Base.logger)
        ::Rails.logger.endpoints << SingletonLogger[output_dir, :rails]
        ::ActionController::Base.logger.endpoints << SingletonLogger[output_dir, :rails]

        class AssetLogger
          APP_ROOT = ::Perscribo::Rails::APP_ROOT

          RAILS_LOGGER = ::Rails.logger
          ASSET_LOGGER = SingletonLogger["#{APP_ROOT}/tmp", :asset]

          def initialize(app)
            @app, ::Rails.application.assets.logger = app, ASSET_LOGGER
          end

          def call(env)
            ::Rails.logger = ASSET_LOGGER if env['PATH_INFO'] =~ /$\/asset|__rack\//
            @app.call(env)
          ensure
            ::Rails.logger = RAILS_LOGGER
          end
        end

        ::Rails.application.config.middleware.insert_before ::Rails::Rack::Logger, AssetLogger
      end
    end
  end
end
