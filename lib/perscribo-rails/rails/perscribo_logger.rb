require 'perscribo/logger'

ENV['RACK_ENV'] ||= 'development'

module Perscribo
  class PerscriboLogger < ::Perscribo::Logger
    attr_accessor :endpoints

    def initialize(*args)
      super(*args)
      @endpoints = []
      self.level = ::Logger::DEBUG
    end

    def add(*args)
      endpoints.each { |i| i.add(*args) }
      super(*args)
    end
  end

  class Engine < ::Rails::Engine
    isolate_namespace Perscribo

    config.after_initialize do
      path = "#{Rails.root}/tmp/perscribo_rails_#{ENV['RACK_ENV']}.log"
      perscribo_logger = PerscriboLogger.new(path)
      perscribo_logger.endpoints << Rails.logger
      Rails.logger = ActionController::Base.logger = perscribo_logger
    end
  end
end
