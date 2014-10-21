require 'perscribo/logger'

require 'active_support/core_ext/object/try'

module Perscribo
  module Rails
    class Logger < ::Perscribo::MultiLogger
      def initialize(*args)
        super(*args)
        label = :rails
      end

      def self.singleton_instance(root_path, do_force = false)
        pid = singleton_pidfile(root_path, label)
        log = singleton_logfile(root_path, label)
        do_force ? respawn_singleton(log, pid, label) : reclaim_singleton(log, pid, label)
      end
    end
  end
end
