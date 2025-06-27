class RolesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_role, only: %i[show edit update destroy]

  # GET /roles or /roles.json
  def index
    unless current_admin.can('role', 'read')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @q = Role.ransack(params[:q])
    @q.sorts = 'id desc' if @q.sorts.empty?

    result = @q.result(distinct: true).order("#{sort_column} #{sort_direction}")
    @pagy, @roles = pagy(result, items: (params[:limit] || 25).to_i)

    render layout: 'admin'
  end

  # GET /roles/1 or /roles/1.json
  def show
    unless current_admin.can('role', 'read')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    render layout: 'admin'
  end

  # GET /roles/new
  def new
    unless current_admin.can('role', 'create')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @role = Role.new
    render layout: 'admin'
  end

  # GET /roles/1/edit
  def edit
    unless current_admin.can('role', 'update')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    render layout: 'admin'
  end

  # POST /roles or /roles.json
  def create
    unless current_admin.can('role', 'create')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to role_url(@role), notice: 'Role was successfully created.', layout: 'admin' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1 or /roles/1.json
  def update
    unless current_admin.can('role', 'update')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to role_url(@role), notice: 'Role was successfully updated.', layout: 'admin' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    unless current_admin.can('role', 'delete')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @role.destroy

    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue StandardError
    redirect_to roles_url, alert: 'No se puede borrar el rol porque tiene usuarios asociados.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:role).permit(:name,
                                 :admin_create, :admin_read, :admin_update, :admin_delete,
                                 :role_create, :role_read, :role_update, :role_delete,
                                 :participant_create, :participant_read, :participant_update, :participant_delete,
                                 :participation_create, :participation_read, :participation_update, :participation_delete,
                                 :product_create, :product_delete, :product_update, :product_read,
                                 :category_read, :category_update, :category_create, :category_delete,
                                 :code_read, :code_update, :code_create, :code_delete,
                                 :winner_create, :winner_read, :winner_update, :winner_delete,
                                 :banned_create, :banned_read, :banned_update, :banned_delete,
                                 :city_promotion_create, :city_promotion_read, :city_promotion_update, :city_promotion_delete,
                                 :branch_promotion_create, :branch_promotion_read, :branch_promotion_update, :branch_promotion_delete)
  end

  def sort_column
    Role.column_names.include?(params[:sort]) ? params[:sort] : 'id'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
