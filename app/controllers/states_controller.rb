class StatesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_state, only: %i[show edit update destroy]

  # GET /states or /states.json
  def index
    @q = State.ransack(params[:q])
    @q.sorts = 'id desc' if @q.sorts.empty?

    result = @q.result(distinct: true).order("#{sort_column} #{sort_direction}")
    @pagy, @states = pagy(result, items: (params[:limit] || 18).to_i)

    render layout: 'admin'
  end

  # GET /states/1 or /states/1.json
  def show
    render layout: 'admin'
  end

  # GET /states/new
  def new
    @state = State.new
    render layout: 'admin'
  end

  # GET /states/1/edit
  def edit
    render layout: 'admin'
  end

  # POST /states or /states.json
  def create
    @state = State.new(state_params)

    respond_to do |format|
      if @state.save
        format.html { redirect_to state_url(@state), notice: 'State was successfully created.', layout: 'admin' }
        format.json { render :show, status: :created, location: @state }
      else
        format.html { render :new, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /states/1 or /states/1.json
  def update
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to state_url(@state), notice: 'State was successfully updated.', layout: 'admin' }
        format.json { render :show, status: :ok, location: @state }
      else
        format.html { render :edit, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1 or /states/1.json
  def destroy
    @state.destroy

    respond_to do |format|
      format.html { redirect_to states_url, notice: 'State was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_state
    @state = State.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def state_params
    params.require(:state).permit(:name, :active)
  end

  def sort_column
    State.column_names.include?(params[:sort]) ? params[:sort] : 'id'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
