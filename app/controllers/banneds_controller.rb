class BannedsController < ApplicationController
  before_action :set_banned, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!
  layout 'admin'

  # GET /banneds or /banneds.json
  def index
    @q=Banned.ransack params[:q]
    @banneds = @q.result.page(params[:page]).per(params[:limit])
  end

  # GET /banneds/1 or /banneds/1.json
  def show
  end

  # GET /banneds/new
  def new
    @banned = Banned.new
  end

  # GET /banneds/1/edit
  def edit
  end

  # POST /banneds or /banneds.json
  def create
    @banned = Banned.new(banned_params)

    respond_to do |format|
      if @banned.save
        format.html { redirect_to banneds_url, notice: "Creado." }
        format.json { render :show, status: :created, location: @banned }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @banned.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banneds/1 or /banneds/1.json
  def update
    respond_to do |format|
      if @banned.update(banned_params)
        format.html { redirect_to banned_url(@banned), notice: "Actualizado." }
        format.json { render :show, status: :ok, location: @banned }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @banned.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banneds/1 or /banneds/1.json
  def destroy
    @banned.destroy

    respond_to do |format|
      format.html { redirect_to banneds_url, notice: "Banned was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banned
      @banned = Banned.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def banned_params
      params.require(:banned).permit(:document)
    end
end
