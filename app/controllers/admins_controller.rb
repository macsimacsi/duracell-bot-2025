class AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin, only: %i[show destroy edit update]

  def sort
    params[:sort].each_with_index do |id, index|
      params[:model].constantize.where(id: id).update_all(position: index + 1)
    end
    head :ok
  end

  def index
    unless current_admin.can('admin', 'read')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @pagy, @admins = pagy(Admin.all.order("#{sort_column} #{sort_direction}"), items: 10)
    render layout: 'admin'
  end

  def show
    unless current_admin.can('admin', 'read')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @admin = Admin.find(params[:id])
    render layout: 'admin'
  end

  def edit
    unless current_admin.can('admin', 'update')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @resource_name = 'admin'
    render layout: 'admin'
  end

  def new
    unless current_admin.can('admin', 'create')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @admin = Admin.new
    render layout: 'admin'
  end

  # POST
  def create
    unless current_admin.can('admin', 'create')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to admins_path, notice: 'admin was successfully created.' }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    unless current_admin.can('admin', 'update')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end
    update_params = admin_params
    if update_params[:password].blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
    end
    respond_to do |format|
      if @admin.update(update_params)
        format.html { redirect_to admins_path, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity, layout: 'admin' }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless current_admin.can('admin', 'delete')
      redirect_to dashboard_path, notice: 'Permisos insuficientes para esta operación'
      return
    end

    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_index_url, notice: 'Administrador borrado exitosamente.' }
      format.json { head :no_content }
    end
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation, :role_id)
  end

  def sort_column
    Admin.column_names.include?(params[:sort]) ? params[:sort] : 'id'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
