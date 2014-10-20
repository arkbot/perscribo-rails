require 'perscribo/logger'

require 'active_support/core_ext/object/try'

module Perscribo
  module Rails
    class MultiLogger < ::Perscribo::Logger
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

      def self.singleton_instance(root_path = "#{Dir.pwd}", do_force = false)
        pid, log = singleton_pidfile(root_path), singleton_logfile(root_path)
        do_force ? respawn_singleton(log, pid) : reclaim_singleton(log, pid)
      end

      def self.respawn_singleton(log_file, pid_file)
        at_exit { File.delete(pid_file) if File.exists?(pid_file) }
        File.delete(pid_file) if File.exists?(pid_file)
        new(log_file).instance_eval do
          File.open(pid_file, 'w+') { |f| f.write(try(:__id__) || '') }
          self
        end
      end

      def self.reclaim_singleton(log_file, pid_file)
        begin
          object_id = IO.read(pid_file)
          logger = ObjectSpace._id2ref(object_id)
          logger.nil? ? respawn_singleton(log_file, pid_file) : logger
        rescue
          respawn_singleton(log_file, pid_file)
        end
      end

      def self.singleton_pidfile(root_path)
        "#{root_path}/tmp/pids/multilogger.object_id"
      end

      def self.singleton_logfile(root_path)
        "#{root_path}/tmp/perscribo_rails_#{ENV['RACK_ENV']}.log"
      end

      SINGLETON_METHODS = methods(false).select do |i|
        i.to_s =~ /((.+)?_?singleton(?!_instance)(.+)?)/
      end

      private_class_method *SINGLETON_METHODS
    end
  end
end
