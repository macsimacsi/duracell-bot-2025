# frozen_string_literal: true

def setup_logger
  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = Rails.application.config.log_formatter
  Rails.logger = ActiveSupport::TaggedLogging.new(logger)
end

def logger(message, level = :info)
  Rails.logger.send(level, message)
end

setup_logger

def print_errors(resource = nil, &block)
  resource = yield if block
  resource&.errors&.each do |error|
    color_code = 31
    print "\e[#{color_code}m#{"Error: #{error.attribute}: #{error.message}\n"}\e[0m"
  end
end

def attachable_io(path, folder = Rails.public_path.join('seeder/').to_s)
  { io: File.open("#{folder}#{path}"), filename: File.basename("#{folder}#{path}") }
end

if ENV['FILE'].blank?
  logger "No se especificó ningun archivo. Ejecuta el seeder de la siguiente manera:\n"
  logger "\trails db:seed FILE=*\t# Ejecuta todos los seeders"
  logger "\trails db:seed FILE=001\t# Ejecuta el seeder 001_*.rb\n"
else
  Dir[Rails.root.join("db/seeds/#{ENV["FILE"]}_*.rb").to_s].each do |file|
    logger "Ejecutando el archivo '#{file}'"
    require file
  end
end
