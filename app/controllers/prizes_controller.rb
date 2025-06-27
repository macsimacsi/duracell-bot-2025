class PrizesController < ApplicationController
  layout 'admin'
  before_action :set_prize, only: %i[show edit update destroy]
  # http_basic_authenticate_with :name => "admin", :password => "Admin#1234@"
  before_action :authenticate_admin!
  # GET /prizes or /prizes.json
  def index
    @q = Prize.ransack(params[:q])
    @pagy, @prizes = pagy(@q.result.order(created_at: :desc), items: params[:limit] || 25)
    @prizes = Prize.all

    @prize_ordered = Prize.where(active: true).ordered
    respond_to do |format|
      format.html do
        render :index
      end
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename=premios.xlsx'

        render :index
      end
    end
  end

  # GET /prizes/1 or /prizes/1.json
  def show
    render layout: 'admin'
  end

  # GET /prizes/new
  def new
    @prize = Prize.new
    render layout: 'admin'
  end

  # GET /prizes/1/edit
  def edit
    render layout: 'admin'
  end

  # POST /prizes or /prizes.json
  def create
    @prize = Prize.new(prize_params)

    respond_to do |format|
      if @prize.save
        format.html { redirect_to prize_url(@prize), notice: 'Prize was successfully created.' }
        format.json { render :show, status: :created, location: @prize }
      else
        format.html { render :new, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @prize.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prizes/1 or /prizes/1.json
  def update
    respond_to do |format|
      if @prize.update(prize_params)
        format.html { redirect_to prize_url(@prize), notice: 'Prize was successfully updated.' }
        format.json { render :show, status: :ok, location: @prize }
      else
        format.html { render :edit, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @prize.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prizes/1 or /prizes/1.json
  def destroy
    @prize.destroy

    respond_to do |format|
      format.html { redirect_to prizes_url, notice: 'Prize was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_prize
    @prize = Prize.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def prize_params
    params.require(:prize).permit(:name, :active, :quantity, :step, :position)
  end
end
