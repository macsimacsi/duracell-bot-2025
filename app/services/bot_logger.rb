require 'logger'

class BotLogger
  LOG_PATH = Rails.root.join('log', 'bot.log')

  def self.logger
    @logger ||= Logger.new(LOG_PATH).tap do |log|
      log.level = Logger::INFO
      log.formatter = proc do |severity, datetime, _progname, msg|
        "[#{datetime.strftime('%H:%M:%S')}] #{msg}\n"
      end
    end
  end

  def self.entry(contact, state, body)
    logger.info "📩 [ENTRY]    [#{contact}] Estado=#{state} | Msg='#{body}'"
  end

  def self.response(contact, state, message)
    logger.info "📤 [REPLY]    [#{contact}] Estado=#{state} | Respuesta='#{message}'"
  end

  def self.state_change(contact, new_state)
    logger.info "🔁 [STATE]    [#{contact}] Estado → #{new_state}"
  end

  def self.done(contact)
    logger.info "🏁 [DONE]     [#{contact}] Participación registrada exitosamente."
  end

  def self.error(contact, state, error_msg)
    logger.error "❗ [ERROR]    [#{contact}] Estado=#{state} | #{error_msg}"
  end
end
