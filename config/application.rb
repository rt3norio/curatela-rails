require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Monkey patch to fix Litestack 0.4.3 compatibility with Rails 8.1
# The sqlite3_production_warning configuration was removed in Rails 8.1
# but Litestack railtie tries to set it during initialization
module ActiveRecordSqlite3ProductionWarningPatch
  def sqlite3_production_warning=(value)
    # No-op: this configuration was removed in Rails 8.1
    # Litestack tries to set this to false, but it's not needed anymore
  end
  
  def sqlite3_production_warning
    nil
  end
end

ActiveRecord::Base.singleton_class.prepend(ActiveRecordSqlite3ProductionWarningPatch)

module CuratelaLegalRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
