RubyTester::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.compile = true
  config.assets.digest = true
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  # config.assets.manifest = YOUR_PATH
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  # config.force_ssl = true
  # config.log_level = :debug
  # config.log_tags = [ :subdomain, :uuid ]
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
  # config.cache_store = :mem_cache_store
  # config.assets.precompile += %w( search.js )
  # config.action_mailer.raise_delivery_errors = false
  # config.threadsafe!
end
