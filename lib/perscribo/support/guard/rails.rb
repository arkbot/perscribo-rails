require 'perscribo/guard'

module Perscribo
  module Support
    module Guard
      module Rails
        OUT_PATH = "#{Dir.pwd}/tmp/perscribo_rails_#{ENV['RACK_ENV']}.log"
        DEFAULTS = {
          labels: [:debug, :info, :warn, :error, :fatal, :unknown],
          guard_opts: {
            daemon: true,
            # debug: true,
            environment: "#{ENV['RACK_ENV']}",
            force_run: true,
            port: 3000,
            timeout: 5,
            start_on_start: true
          },
          path: OUT_PATH,
          watcher_opts: { rewind_on_touch: false }
        }

        ::Perscribo::Guard.capture!(self)
      end
    end
  end
end
