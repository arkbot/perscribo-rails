RAILS_LOG = "#{Dir.pwd}/tmp/perscribo_rails_#{ENV['RACK_ENV']}.log"
DEFAULT_RAILS_OPTS = {
  daemon: true,
  # debug: true,
  environment: 'development',
  force_run: true,
  port: 3000,
  start_on_start: true
}
RAILS_WATCHER_OPTS = { truncate_on_read: true }
LOGGER_LABELS = [:debug, :info, :warn, :error, :fatal, :unknown]
log_output_with_options('RAILS', RAILS_LOG, RAILS_WATCHER_OPTS, *LOGGER_LABELS)
