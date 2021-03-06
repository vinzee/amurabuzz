require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "net/http"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module AmuraBuzz
  class Application < Rails::Application
    #config.action_view.sanitized_allowed_tags = "span","a"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # config.i18n.fallbacks = true
    # config.i18n.default_locale = "en-IN"

    config.active_record.observers = :relationship_observer, :comment_observer, :vote_observer, :tweet_observer, :user_observer, :image_observer

    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
        g.test_framework :rspec,
        :fixtures => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true
        g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
  end
end

require "encryption"
