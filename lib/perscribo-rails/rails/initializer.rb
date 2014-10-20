require 'perscribo-rails/rails/multi_logger'

ENV['RACK_ENV'] ||= 'development'

module Perscribo
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Perscribo

      # config.after_initialize do
      config.before_initialize do
        multilogger = MultiLogger.singleton_instance(::Rails.root)
        multilogger.endpoints << ::Rails.logger
        ::Rails.logger = ActionController::Base.logger = multilogger
      end
    end
  end
end
