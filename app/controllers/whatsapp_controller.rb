class WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    if request.get?
      verify_token = 'GDigital'
      mode = params['hub.mode']
      token = params['hub.verify_token']
      challenge = params['hub.challenge']

      return render plain: challenge, status: 200 if mode == 'subscribe' && token == verify_token

      return render plain: 'Unauthorized', status: 403

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
        message = <<~MSG.strip
          👋 ¡Hola! Gracias por participar en la promo Duracell te lleva al GP de Sao Paulo🏁
          Para inscribirte al sorteo, por favor completá algunos datos. ¡No te tomará más de un minuto!

          🪪 *Primero, ingresá tu número de Cédula de Identidad (sin puntos ni guiones):*
        MSG
        participant.status = 1
      when 1 # Se registra el número de cédula y se solicita el departamento
        if type == 'text' && is_number?(body)
          participant.document = body
          participant.status = 2
          department = State.active.order(:id)
          options = department.map { |d| "#{d.id}- #{d.name}" }.join("\n")
          message = <<~MSG.strip
            Gracias por tu respuesta!#{' '}
            📍¿En qué departamento del país vivís?
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
            ¡Gracias por tu respuesta!

            Ahora, por favor, indícanos tu edad.
          MSG
          BotLogger.response(from, participant.status, message)
          BotLogger.state_change(from, participant.status)
        else
          message = 'Envianos SOLO el número del departamento (Ej: 0 a 18).'
          BotLogger.error(from, participant.status, message)
        end
      when 3 # Se registra la edad y se solicita el genero
        if type == 'text' && is_number?(body) && (18..100).include?(body.to_i)
          participant.age = body.to_i
          participant.status = 4
          message = <<~MSG.strip
            🙋‍♀️🙋‍♂️ ¿Cuál es tu género?

            1. Femenino
            2. Masculino
            3. Prefiero no decir
            4. Otro
          MSG
        else
          message = 'Debés ser mayor de edad para participar.'
          BotLogger.error(from, participant.status, message)
        end
      when 4
        if type == 'text' && is_number?(body) && (1..4).include?(body.to_i)
          participant.genre = body.to_i - 1
          participant.status = 5

          message = '🧾 Ingresá los ultimos 4 numeros de tu factura de compra:'
        else
          message = <<~MSG.strip
            Por favor respondé con un número del 1 al 4 según tu género:
            1. Femenino
            2. Masculino
            3. Prefiero no decir
            4. Otro
          MSG
          BotLogger.error(from, participant.status, message)
        end
      when 5
        if is_number?(body)
          participant.status = 6
          participant.participations.create!(receipt: body, product_id: nil)
          message = <<~MSG.strip
            🏪 ¿En qué local hiciste tu compra?
          MSG
        else
          message = 'Por favor, ingresá un número de factura válido (4 dígitos).'
        end
      when 6 # Registra el local de compra y setea el nro de factura
        if type == 'text' && body.present?
          participation = participant.participations.last
          participation.local_str = body
          options = Product.active.map { |p| "#{p.id}- #{p.name}" }.join("\n")
          participation.save!
          message = <<~MSG.strip
            🔋 ¿Qué tipo de pila compraste? Seleccioná una opción:
            #{options}
          MSG
          participant.status = 7
        elsif body.present? && participant.participations.last.present?
          # Si el participante ya tiene una participación, se registra la respuesta
          participation.status = 5
          participant.participation.create(
            receipt: body,
            product_id: nil
          )
          message = <<~MSG.strip
            ¡Gracias por tu respuesta!#{' '}

            🏪 ¿En qué local hiciste tu compra?
          MSG
        else
          message = 'Por favor, ingresá el nombre del local donde realizaste la compra.'
          BotLogger.error(from, participant.status, message)
        end
      when 7 # Se pregunta por la cantidad del producto
        if type == 'text' && body.present? && (1..8).include?(body.to_i)
          participant.status = 8
          participation = participant.participations.last
          participation.product_id = body.to_i
          participation.save!
          qty = %w[16 8 6 4 2 1]
          qty = qty.map { |q| "#{q}" }.join("\n")
          message = <<~MSG.strip
              🔢 ¿Cuántas pilas tenía el producto comprado?
              🔘 Opciones:
            #{qty}
          MSG
        else
          message = 'Por favor, seleccioná una opción del 1 al 8.'
        end
      when 8 # Se registra la cantidad de pilas compradas
        if type == 'text' && is_number?(body) && %w[16 8 6 4 2 1].include?(body)
          participant.status = 9
          participation = participant.participations.last
          participation.product_qty = body.to_i
          participation.save!
          message = <<~MSG.strip
            📸 Por favor, subí una foto nítida del comprobante de compra donde se vean los datos de la compra.
          MSG
        else
          message = 'Por favor, ingresá un número válido de pilas compradas.'
        end
      when 9 # Se solicita la foto del comprobante de compra
        if type == 'image'
          media_id = params.dig(:entry, 0, :changes, 0, :value, :messages, 0, :image, :id)

          if media_id.present?
            media_url = w.get_media_url(media_id)

            if media_url.present?
              downloaded_image = URI.open(media_url, 'Authorization' => w.token)

              participation = participant.participations.last
              participation.image.attach(io: downloaded_image, filename: "comprobante-#{participant.document}.jpg",
                                         content_type: 'image/jpeg')

              participant.status = 10
              message = <<~MSG.strip
                ✅ ¡Gracias por completar tu inscripción!#{' '}
                Ya estás participando en el sorteo Duracell te lleva al F1 🏎️

                Te contactaremos por este medio si sos uno de los ganadores.
                *(No olvides guardar tu factura de compra)*

                🔗Términos y condiciones del sorteo.#{' '}
              MSG
            else
              message = 'No pudimos acceder a la imagen. Por favor, intentá nuevamente.'
            end
          else
            message = 'No encontramos la imagen. Asegurate de subir una foto válida del comprobante.'
          end
        else
          message = 'Por favor, subí una foto nítida del comprobante de compra.'
        end
      when 10 # Participación finalizada
        message = <<~MSG.strip
          👋 ¡Hola de vuelta!

          🧾 Ingresá los ultimos 4 numeros de tu factura de compra para seguir sumando puntos:
        MSG
        participant.status = 5
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
