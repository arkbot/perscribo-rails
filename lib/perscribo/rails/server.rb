require 'perscribo/support/core/dsl'
require 'perscribo/support/core/io'

require 'rails/commands/server'

module Perscribo
  module Rails
    # class Server < ::Rails::Server
    #   def print_boot_information
    #     # ...
    #     super
    #   end
    # end
    unless const_defined?(:Server, false)
      module Server
        module Bootstraps
          module PrependMethods
            def print_boot_information
              root, opts = lambda { ::Rails.root }.call, [:rails, :info, root]
              original_stdout, original_stderr = $stdout, $stderr
              begin
                $stdout = Support::Core::IO::LoggerIO.hook!($stdout, *opts)
                $stderr = Support::Core::IO::LoggerIO.hook!($stderr, *opts)
                super
              ensure
                $stdout, $stderr = original_stdout, original_stderr
              end
            end
          end
        end

        # TODO: May be able bootstrap! inside engine.
        include Support::Core::Dsl::Bootstrappable
        bootstrap!(::Rails::Server)
      end
    end
  end
end
