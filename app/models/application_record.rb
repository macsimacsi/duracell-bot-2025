class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  after_validation :log_errors

  private

  def log_errors
    return if errors.empty?

    error_messages = errors.map { |e| "#{e.attribute}: #{e.message}" }.join(', ')
    Rails.logger.warn("Validation error: #{error_messages}")
  end
end
