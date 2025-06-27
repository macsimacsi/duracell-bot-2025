class WhatsappCampaignsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @filtered_contacts = fetch_filtered_contacts
    render layout: 'admin'
  end

  def whatsapp_campaigns_data
    @filtered_contacts = fetch_filtered_contacts
    render json: { contacts: @filtered_contacts.count }
  end

  def create
    template = 'winners_announcement'
    whatsapp = WhatsApp.new(Rails.application.config.whatsapp_token)
    wait_time = 10
    @filtered_contacts = fetch_filtered_contacts

    results = @filtered_contacts.map do |phone|
      puts "Esperando #{wait_time} segundos para enviar el mensaje a #{phone}"
      sleep(wait_time)
      res = whatsapp.send_template_message(phone, template_name: template, language: 'es')
      {
        phone: phone,
        status: res.code == '200' ? 'sent' : 'error',
        response: res.body
      }
    end

    sent = results.map { |r| r[:status] == 'sent' ? r[:phone] : nil }.compact

    if results.empty?
      flash[:alert] = "⚠️ Todos los contactos están dados de baja o no se enviaron mensajes."
    elsif results.all? { |r| r[:status] == 'sent' }
      flash[:notice] = "✅ Mensaje enviado correctamente a #{results.size} contacto(s)."
      Participant.where(contact: sent).update_all(received_template: true)
    else
      flash[:alert] = "⚠️ Algunos mensajes fallaron: #{results.map { |r| "#{r[:phone]} (#{r[:status]})" }.join(', ')}"
    end

    redirect_to request.referer || root_path
  end

  def options
    head :ok
  end

  private

  def fetch_filtered_contacts
    limit = params[:limit].to_i
    limit = 10 if limit <= 0

    contacts = Participant.joins(:participations).joins("INNER JOIN codes ON codes.value = participations.code_str").distinct.limit(limit).pluck(:contact)
    opt_out_contacts = Participant.where(opt_out: true).pluck(:contact)
    received_template_contacts = Participant.where(received_template: true).pluck(:contact)

    contacts - opt_out_contacts - received_template_contacts
  end
end
