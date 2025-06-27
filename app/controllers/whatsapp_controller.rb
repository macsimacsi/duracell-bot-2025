class WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    if request.get?
      verify_token = "GDigital"
      mode = params['hub.mode']
      token = params['hub.verify_token']
      challenge = params['hub.challenge']

      if mode == 'subscribe' && token == verify_token
        return render plain: challenge, status: 200
      else
        return render plain: "Unauthorized", status: 403
      end
    else
      return unless params&.dig(:entry, 0, :changes, 0, :value, :messages)

      token = Rails.application.config.whatsapp_token
      message = media_message = nil
      img = '/img/lote.jpg'
      image = request.base_url + "/#{img}"
      w = WhatsApp.new(token, params)
      type = w.type

      name = params.dig(:entry, 0, :changes, 0, :value, :contacts, 0, :profile, :name)
      body = params.dig(:entry, 0, :changes, 0, :value, :messages, 0, :text, :body)&.strip
      from = params.dig(:entry, 0, :changes, 0, :value, :messages, 0, :from)
      message_type = params.dig(:entry, 0, :changes, 0, :value, :messages, 0, :type)

      participant = Participant.find_or_initialize_by(contact: from)

      case participant.status.to_i
      when 0 # Se crea el participante
        BotLogger.entry(from, participant.status, body)
        message =message = <<~MSG.strip
        ¡Hola! 👋🤩
        Bienvenido/a a la promo UN VINO PARA TODO HASTA PARA GANAR de VINO SANTA HELENA 🍇🍷

        Para participar, necesitamos que nos envíes tu *número de cédula sin puntos ni espacios* (ejemplo: 1234567) por única vez para registrarte a la promoción. ✍🏼

        Podes leer las bases y condiciones de la promo aquí:
        https://santahelenabot.gdigital.com.py/img/ByC.pdf
        MSG
        participant.status = 1
      when 1 # Se registra el número de cédula y se solicita la ciudad
        if type == 'text' && is_number?(body)
          participant.document = body
          participant.status = 2
          department = State.active.order(:id)
          options = department.map { |d| "#{d.id}- #{d.name}" }.join("\n")
          message = <<~MSG.strip
          Gracias por tu respuesta! Ahora, por favor, indícanos en qué departamento de Paraguay vivís. 📍

          Envíanos SOLO el número del departamento (Ej: 1)
          #{options}
        MSG

          BotLogger.response(from, participant.status, message)
          BotLogger.state_change(from, participant.status)
        else
          message = "Por favor, ingresá un número de cédula válido.\nEjemplo: 1234567"
          BotLogger.error(from, participant.status, message)
        end

      when 2 # Se registra el departamento y se solicita la edad
        if type == 'text' && is_number?(body) && (1..18).include?(body.to_i)
          participant.state_id = body
          participant.status = 3
          message = <<~MSG.strip
          Gracias por tu respuesta!
          Ahora, por favor, indícanos tu edad.
          MSG
          BotLogger.response(from, participant.status, message)
          BotLogger.state_change(from, participant.status)
        else
          message = "Envianos SOLO el número del departamento (Ej: 0 a 18)."
          BotLogger.error(from, participant.status, message)
        end

      when 3 # Se registra la edad y se solicita la primera participación
        if type == 'text' && is_number?(body) && (18..100).include?(body.to_i)
          participant.age = body.to_i
          participant.status = 4
          message = "Por último precisamos el número de LOTE que se encuentra al dorso de cada botella (Ej: L12345)"
          BotLogger.response(from, participant.status, message)
          BotLogger.state_change(from, participant.status)
        else
          message = <<~MSG.strip
          Envianos tu edad en formato numérico (Ej: 26).
          Además, recordá que tenés que ser *mayor de 18 años* para participar.
          MSG
          BotLogger.error(from, participant.status, message)
        end

      when 4 # Se crea la primera participación
        if body.present?
          participation = participant.participations.create!(
            code_str: body
            )
          participant.status = 5
          message = <<~MSG.strip
            🎉 ¡Ya estás registrado/a en la promoción *UN VINO PARA TODO HASTA PARA GANAR*!
            Para más detalles, seguinos en nuestra cuenta @vinossantahelena_py y no te pierdas ninguna novedad.
          MSG
          BotLogger.response(from, participant.status, message)
          BotLogger.state_change(from, participant.status)
        else
          message = "Por favor, escribí el número de LOTE que se encuentra al dorso de la botella (Ej: L12345)."
          BotLogger.error(from, participant.status, message)
        end

      when 5 # Estatus intermedio, para mejor UX
        if type == 'text' && body.present?
          message = "Hola! Si querés registrar otra botella, respondé con el número de lote."
          participant.status = 6
          BotLogger.response(from, participant.status, message)
          BotLogger.state_change(from, participant.status)
        end

      when 6 # Se registran las siguientes participaciones
        if type == 'text' && body.present?
        participant.status = 5
          participant.participations.create!(
            code_str: body
            )
          message = <<~MSG.strip
          🎉 ¡Ya estás registrado/a en la promoción *UN VINO PARA TODO HASTA PARA GANAR*!
          Para más detalles, seguinos en nuestra cuenta @vinossantahelena_py y no te pierdas ninguna novedad.
        MSG
        BotLogger.response(from, participant.status, message)
        BotLogger.state_change(from, participant.status)
        BotLogger.done(from)
        end
      end

      participant.save!
      w.send_plain_message(message, from) if message.present?
      w.send_media(media_message.first, media_message.last, from) if media_message.present?

      if from
        begin
          conv = Conversation.find_or_create_by(contact: from)
          conv&.messages&.create(uuid: request.uuid, body: body, response: message, kind: type)
        rescue StandardError => e
          Rails.logger.error "Message Error: #{e.message}"
        end
      end
    end

    render json: { success: true }
  end

  private

  def is_number?(str)
    Integer(str, exception: false).present?
  end
end
