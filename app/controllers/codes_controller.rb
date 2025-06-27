class CodesController < ApplicationController
  before_action :set_code, only: %i[show edit update destroy]
  before_action :authenticate_admin!
  layout 'admin'

  def index
    @q = Code.ransack params[:q]
    @q.sorts = 'id desc' if @q.sorts.empty?
    @codes = @q.result.page(params[:page]).per(params[:limit])
  end

  def show
  end

  def new
    @code = Code.new
  end

  def create
    @code = Code.new(code_params)
    respond_to do |format|
      if @code.save
        format.html { redirect_to code_url(@code), notice: "code was successfully created." }
        format.json { render :show, status: :created, location: @code }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @code.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @code.update(code_params)
        format.html { redirect_to code_url(@code), notice: "code was successfully updated." }
        format.json { render :show, status: :ok, location: @code }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @code.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @code.destroy
    respond_to do |format|
      format.html { redirect_to codes_url, notice: "code was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def invalid
    @codes = Participation.with_invalid_code
    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename=invalid_codes.xlsx"}
      format.html {render :invalid}
    end
  end

  private

  def set_code
    @code = Code.find(params[:id])
  end

  def code_params
    params.require(:code).permit(:value, :product_id)
  end
end
