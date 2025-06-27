require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Rails

module Tools
  class Application < Rails::Application
    config.load_defaults 6.1
    config.time_zone = 'America/Asuncion'

    config.whatsapp_messages_endpoint = "https://graph.facebook.com/v21.0/#{ENV['ID_PHONE_NUMBER']}/messages"
    config.whatsapp_phone_number_id = ENV['ID_PHONE_NUMBER']
    config.whatsapp_media_endpoint = 'https://graph.facebook.com/v21.0/'
    config.whatsapp_token = "Bearer #{ENV['WHATSAPP_TOKEN']}"
    config.action_cable.mount_path = '/cable'
    config.hosts << 'santahelena.gdigital.cc'
    config.hosts << '127.0.0.1'
    config.hosts << 'localhost'
    config.hosts << 'santahelenabot.gdigital.com.py'

    config.hosts += ENV.fetch('ALLOWED_HOSTS', '').split(',').map(&:strip)
  end
end
