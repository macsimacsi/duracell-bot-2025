class WhatsApp
  require 'net/http'
  attr_accessor :token, :json, :type

  WHATSAPP_API_URL = "https://graph.facebook.com/v22.0"

  def initialize(token, json = nil)
    @token = token
    self.json = json
    self.type = self.json&.dig(:entry, 0, :changes, 0, :value, :messages, 0, :type)
  end

  # 📩 Enviar mensaje de texto plano
  def send_plain_message(message_body, to)
    Rails.logger.info("### Call to send_plain_message")
    uri, req = net_get_base_request

    req.body = {
      messaging_product: 'whatsapp',
      recipient_type: 'individual',
      to: to,
      type: 'text',
      text: {
        preview_url: false,
        body: message_body
      }
    }.to_json

    Rails.logger.info("#### #{req.body}")
    res = net_do_request(uri, req)
    js = JSON.parse(res.body)
    Rails.logger.info(js)
    Rails.logger.info("### End of call to send_plain_message")
    js
  end

  # 🖼️ Enviar imagen, audio, video, etc.
  def send_media(media_type, media_url, to)
    uri, req = net_get_base_request

    req.body = {
      messaging_product: 'whatsapp',
      recipient_type: 'individual',
      to: to,
      type: media_type,
      media_type => { link: media_url }
    }.to_json

    res = net_do_request(uri, req)
    JSON.parse(res.body)
  end

  # 🔁 Enviar mensaje tipo plantilla
  def send_template_message(to, template_name: 'hello_world', language: 'en_US')
    uri = URI(Rails.application.config.whatsapp_messages_endpoint)
    body = 
    {
      messaging_product: "whatsapp",
      to: to,
      type: "template",
      template: {
        name: template_name,
        language: {
          code: language
        },
        components: [
          {
            type: "header",
            parameters: [
              {
                type: "image",
                image: {
                  link: "https://santahelena.gdigital.cc/img/prizes.jpg"
                }
              }
            ]
          }
        ]
      }
    }
    
    
    post(uri, body)
  end
  
  # 📎 Obtener URL de media (cuando te envían una imagen)
  def get_media_url(id)
    uri, req = net_get_base_request_for_media('get', id)
    res = net_do_request(uri, req)
    JSON.parse(res.body)['url']
  end

  # 🔧 Utilidad: ejecutar POST puro (usado por plantilla)
  def post(uri, body)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "#{@token}"
    request.body = body.to_json

    Rails.logger.info "WhatsApp POST body: #{request.body}"

    response = http.request(request)
    Rails.logger.info "WhatsApp API response: #{response.code} - #{response.body}"
    response
  end

  # 🛠 Métodos auxiliares para construcción de requests

  def net_get_base_request
    uri = URI(Rails.application.config.whatsapp_messages_endpoint)
    req = Net::HTTP::Post.new(uri)
    req.content_type = 'application/json'
    req['Authorization'] = @token
    [uri, req]
  end

  def net_get_base_request_for_media(method, id)
    uri = URI("#{Rails.application.config.whatsapp_media_endpoint}#{id}")
    req = method == 'post' ? Net::HTTP::Post.new(uri) : Net::HTTP::Get.new(uri)
    req.content_type = 'application/json'
    req['Authorization'] = @token
    [uri, req]
  end

  def net_do_request(uri, req)
    t1 = Time.now
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    t2 = Time.now

    ApiCall.create(
      url: uri.to_s,
      response_time: ((t2 - t1) * 1000).to_i,
      response_code: response.code,
      response_data: response.read_body,
      response_size: response.body.force_encoding("UTF-8").length,
      data: req.body.to_json,
      method: ApiCall.methods[:post],
      origin: ApiCall.origins[:user]
    )

    response
  end
end
