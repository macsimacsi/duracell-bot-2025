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

    config.whatsapp_phone_number_id = Rails.application.credentials.dig(:meta, :phone_number_id)
    config.whatsapp_messages_endpoint = "https://graph.facebook.com/v22.0/#{config.whatsapp_phone_number_id}/messages"
    config.whatsapp_media_endpoint = 'https://graph.facebook.com/v22.0/'
    config.whatsapp_token = "Bearer #{Rails.application.credentials.dig(:meta, :whatsapp_token)}"

    config.action_cable.mount_path = '/cable'
    config.hosts << 'duracell.gdigital.cc'
    config.hosts << '127.0.0.1'
    config.hosts << 'localhost'
    config.hosts << 'duracellbot.gdigital.com.py'

    config.hosts += ENV.fetch('ALLOWED_HOSTS', '').split(',').map(&:strip)
  end
end
