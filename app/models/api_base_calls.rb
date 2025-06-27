class ApiBaseCalls
    # Base calls to the API endpoints
    def self.get_token
      config_api_host = 'https://massive.chattigo.com/api-bot/login'
      config_api_username = 'apiuser@gdigital'
      config_api_password = 'Api.2022'
      uri = URI(config_api_host)
      body= {username: config_api_username, password: config_api_password}
      t1 = nil
      t2 = nil
      response = nil
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        request.body = body.to_json
        t1 = Time.now
        response = http.request request
        t2 = Time.now
      end
  
      a = ApiCall.create(url: config_api_host,
                     response_time: ((t2 - t1) * 1000).to_i,
                     response_code: response.code,
                     response_data: response.read_body,
                     response_size: response.body.force_encoding("UTF-8").length,
                     method: ApiCall.methods[:post],
                     origin: ApiCall.origins[:user])
  
      JSON.parse response.body
    end
    
    def self.send_message(message_="Test",to_="595976474705", params)
      token = get_token
      config_api_host = "https://massive.chattigo.com/api-bot/outbound"
      uri = URI(config_api_host)
      t1 = nil
      t2 = nil
      response = nil
      body={
        id: params[:id],
        # idChat: params[:idChat],
        # channelProvider: params[:channelProvider],
        # idCampaign: params[:idCampaign],
        name: params[:name],
        isAttachment: false,
        attachment: nil,
        # message: nil,

        did: params[:did], 
        msisdn: params[:msisdn], 
        type: 'text',
        channel: 'WHATSAPP', 
        content: message_.to_s
      }
      
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new(uri,'Authorization' => "Bearer #{token["access_token"]}", 'Content-Type' => 'application/json')
        request.body = body.to_json
        t1 = Time.now
        response = http.request request
        t2 = Time.now
      end
  
      a = ApiCall.create(url: config_api_host,
        response_time: ((t2 - t1) * 1000).to_i,
        data: body.to_json,
        response_code: response.code,
        response_data: response.read_body,
        response_size: response.body.force_encoding("UTF-8").length,
        method: ApiCall.methods[:post],
        origin: ApiCall.origins[:user])
  
      response
    end
  end
  