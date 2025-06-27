class ParticipantsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @q = Participant.ransack(params[:q])
    @q.sorts = 'id desc' if @q.sorts.empty?

    result = @q.result(distinct: true)

    respond_to do |format|
      filename = "Participantes-#{Time.now.strftime('%d-%m-%Y_%H_%M')}"

      format.xlsx do
        @participants = result
        response.headers['Content-Disposition'] = "attachment; filename=\"#{filename}.xlsx\""
      end

      format.html do
        @pagy, @participants = pagy(result, items: (params[:limit] || 25).to_i)
      end
    end
  end

  # GET /participants/1 or /participants/1.json
  def show
    @participant = Participant.find(params[:id])

    # Participación ganadora
    @winning_participation = @participant.participations
                                         .order(created_at: :desc)
                                         .first

    return unless @winning_participation

    @code_value = @winning_participation.code_str
  end

  def edit
    participant
  end

  def create
    @participant = Participant.new(participant_params)

    respond_to do |format|
      if @participant.save
        format.html { redirect_to participant_url(@participant), notice: 'Participant was successfully created.' }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participants/1 or /participants/1.json
  def update
    respond_to do |format|
      if @participant.update(participant_params)
        format.html { redirect_to participant_url(@participant), notice: 'Participant was successfully updated.' }
        format.json { render :show, status: :ok, location: @participant }
      else
        format.html { render :edit, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1 or /participants/1.json
  def destroy
    @participant.destroy

    respond_to do |format|
      format.html { redirect_to participants_url, notice: 'Participant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def participant
    @participant = Participant.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def participant_params
    params.require(:participant).permit(:full_name, :quantity)
  end

  def export_csv
    participants = Participant.all

    csv_data = CSV.generate(headers: true) do |csv|
      csv << %w[ID Contacto Nombre Documento Lugar] # Agrega los encabezados de las columnas según tus necesidades

      participants.each do |participant|
        participant.participations.each do |p|
          csv << [participant.id, participant.contact, participant.full_name, participant.document, Participation.station_names[p.station_name]] # Agrega los datos de cada participante según tus necesidades
        end
      end
    end
    send_data csv_data, filename: "participantes-#{Date.today}.csv", type: 'text/csv'
  end
end
