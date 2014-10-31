require 'perscribo/support/core/dsl'
require 'perscribo/support/core/io'

require 'rails/commands/server'

module Perscribo
  module Rails
    unless const_defined?(:Server, false)
      module Server
        include Support::Core::Dsl::Bootstrappable

        module Bootstraps
          module PrependMethods
            # TODO: use io#stdio in `ensure`
            def print_boot_information
              opts = [:rails, :info, lambda { "#{::Rails.root}/tmp" }.call]
              begin
                logio = ::Perscribo::Support::Core::LoggerIO
                $stdout = logio.hook!($stdout, *opts)
                $stderr = logio.hook!($stderr, *opts)
                super
              ensure
                $stdout, $stderr = $stdout.stdio, $stderr.stdio
              end
            end
          end
        end

        bootstrap!(::Rails::Server)
      end
    end
  end
end
