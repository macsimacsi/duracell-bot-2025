class ApiCallsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_api_call, only: %i[show edit update destroy]

  # GET /api_calls or /api_calls.json
  def index
    @q = ApiCall.ransack(params[:q])
    @api_calls = @q.result(distinct: true).order(id: :desc).page params[:page]

    respond_to do |format|
      format.html { render layout: 'admin' }
      format.csv { send_data @api_calls.to_csv, filename: "api-calls-#{Date.today}.csv" }
    end
  end

  # GET /api_calls/1 or /api_calls/1.json
  def show
    render layout: 'admin'
  end

  # GET /api_calls/new
  def new
    @api_call = ApiCall.new
  end

  # GET /api_calls/1/edit
  def edit; end

  # POST /api_calls or /api_calls.json
  def create
    @api_call = ApiCall.new(api_call_params)

    respond_to do |format|
      if @api_call.save
        format.html { redirect_to @api_call, notice: 'Api call was successfully created.' }
        format.json { render :show, status: :created, location: @api_call }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @api_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api_calls/1 or /api_calls/1.json
  def update
    respond_to do |format|
      if @api_call.update(api_call_params)
        format.html { redirect_to @api_call, notice: 'Api call was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_call }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @api_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_calls/1 or /api_calls/1.json
  def destroy
    @api_call.destroy
    respond_to do |format|
      format.html { redirect_to api_calls_url, notice: 'Api call was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_api_call
    @api_call = ApiCall.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def api_call_params
    params.require(:api_call).permit(:url, :response_code, :response_time)
  end
end
  