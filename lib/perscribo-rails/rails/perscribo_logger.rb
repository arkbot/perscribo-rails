require 'perscribo/logger'

ENV['RAKE_ENV'] ||= 'development'

module Perscribo
  class PerscriboLogger < ::Perscribo::Logger
    attr_accessor :endpoints

    def initialize(*args)
      super(*args)
      @endpoints = []
    end

    def add(*args)
      endpoints.each { |i| i.add(*args) }
      super(*args)
    end
  end

  class Engine < ::Rails::Engine
    isolate_namespace Perscribo

    config.after_initialize do
      original_logger = Rails.logger
      path = "#{Rails.root}/tmp/perscribo_rails_#{ENV['RAKE_ENV']}.log"
      Rails.logger = PerscriboLogger.new(path)
      Rails.logger.endpoints << original_logger
    end
  end
end
