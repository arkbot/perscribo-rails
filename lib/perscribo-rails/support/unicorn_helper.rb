require 'perscribo-rails/rails/multi_logger'
require File.expand_path('../environment',  __FILE__)

multilogger = Perscribo::Rails::MultiLogger.singleton_instance(Rails.root)

before_fork do |server, worker|
  !!(server.logger = multilogger)
end
