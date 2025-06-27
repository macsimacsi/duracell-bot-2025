class ParticipationsController < ApplicationController
  layout 'admin'
  before_action :set_participation, only: %i[show edit update destroy]
  # http_basic_authenticate_with :name => "admin", :password => "Admin#1234@"
  before_action :authenticate_admin!

  def change_status
    @participation = Participation.find(params[:id])
    case params[:new_status]
    when 'approved'
      @participation.status = 1
      @participation.save

      @participation.winner.update(status: 1) if @participation.is_winner
    when 'not_approved'
      Winner.where(participation_id: @participation.id).destroy_all
      @participation.destroy
    end

    Rails.logger.info @participation.errors.messages
    redirect_to participations_path
  end

  # GET /participations or /participations.json
  def index
    @q = Participation.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?

    result = @q.result(distinct: true) # <- si necesitás evitar duplicados

    respond_to do |format|
      filename = "Participaciones-#{Time.now.strftime('%d-%m-%Y_%H_%M')}"

      format.xlsx do
        @participations = result
        response.headers['Content-Disposition'] = "attachment; filename=\"#{filename}.xlsx\""
      end

      format.html do
        @pagy, @participations = pagy(result, items: (params[:limit] || 25).to_i)
      end
    end
  end

  # GET /participations/1 or /participations/1.json
  def show
    render layout: 'admin'
  end

  # GET /participations/new
  def new
    @participation = Participation.new
    render layout: 'admin'
  end

  # GET /participations/1/edit
  def edit
    render layout: 'admin'
  end

  # POST /participations or /participations.json
  def create
    @participation = Participation.new(participation_params)

    respond_to do |format|
      if @participation.save
        format.html { redirect_to participation_url(@participation), notice: 'Participation was successfully created.' }
        format.json { render :show, status: :created, location: @participation }
      else
        format.html { render :new, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participations/1 or /participations/1.json
  def update
    respond_to do |format|
      if @participation.update(participation_params)
        format.html { redirect_to participation_url(@participation), notice: 'Participation was successfully updated.' }
        format.json { render :show, status: :ok, location: @participation }
      else
        format.html { render :edit, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participations/1 or /participations/1.json
  def destroy
    @participation.destroy

    respond_to do |format|
      format.html { redirect_to participations_url, notice: 'Participation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_participation
    @participation = Participation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def participation_params
    params.require(:participation).permit(:participant_id, :image, :full_name, :document, :quantity, :status, :city_id,
                                          :gas_station_id, :product_id)
  end
end
