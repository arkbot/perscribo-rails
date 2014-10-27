require 'perscribo/support/core/logging'

module Perscribo
  module Rails
    # Reference:
    #
    # => http://guides.rubyonrails.org/engines.html
    # => http://guides.rubyonrails.org/configuring.html
    # => http://guides.rubyonrails.org/rails_on_rack.html
    # => http://guides.rubyonrails.org/initialization.html
    #
    # class RackLogger < ::Perscribo::MultiLogger
    #   def initialize(*args)
    #     super(*args)
    #     label = :rack
    #   end
    # end

    class Engine < ::Rails::Engine
      isolate_namespace Perscribo

      config.before_initialize do
        log = Support::Core::Logging::SingletonLogger[::Rails.root, :rails]
        log.endpoints << ::Rails.logger
        ::Rails.logger = ::ActionController::Base.logger = log
      end
    end
  end
end
