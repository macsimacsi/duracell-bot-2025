class WinnersController < ApplicationController
  layout 'admin'
  before_action :set_winner, only: %i[show edit update destroy]
  before_action :authenticate_admin!

  def check
    @msg = 'not found'
    return unless request.post?

    @winner = Winner.find_by_code(params[:winner][:code])
    if @winner
      if @winner.status == 'confirmed_'
        @winner.status = 'delivered_'
        @winner.save
        @msg = 'delivering'
      elsif @winner.status == 'new_'
        @msg = 'not confirmed'
      elsif @winner.status == 'delivered_'
        @msg = 'delivered'
      end
    else
      @msg = 'not found'
    end
  end

  def sorteo
    if request.post?
      states = Array(params[:states]).reject { |c| c == 'all' || c.blank? }
      prize_id = params[:prize_id].presence
      prize = Prize.find_by(id: prize_id)

      banned_docs   = Banned.pluck(:document)
      winner_docs   = Winner.joins(:participant).pluck('participants.document').uniq
      excluded_docs = (banned_docs + winner_docs).uniq

      participants = Participant
                     .joins(:participations)
                     .where.not(participants: { document: [nil, '', *excluded_docs] })
                     .distinct

      participants = participants.where(state_id: states) if states.any?

      if participants.empty?
        render json: { error: 'No se encontró un ganador. Vuelve a intentar el sorteo' }, status: :unprocessable_entity
        return
      end

      winner = participants.sample

      Winner.create!(participant: winner, prize: prize)

      last_participation = winner.participations
                                 .joins('INNER JOIN codes ON codes.value = participations.code_str')
                                 .order(created_at: :desc)
                                 .first

      code_value = last_participation&.code_str
      product_name = Code.find_by(value: code_value)&.product&.name

      render json: {
        ci: winner.document,
        numero: winner.contact.to_s[0..-4] + '***',
        departamento: winner.state&.name || 'Sin departamento',
        premio: prize&.name || 'Sin premio asignado',
        codigo: code_value
      }

      Rails.logger.info "Ganador: #{winner.inspect}"
      Rails.logger.info "Premio: #{prize&.name}"
    else
      render layout: 'sorteo'
    end
  end

  def sorteo_config
    @states = State.all
    @prizes = Prize.ordered.actives
    render layout: 'admin'
  end

  # GET /admin/sorteo_count
  def sorteo_count
    categories = Array(params[:categories]).reject { |c| c == 'all' || c.blank? }
    products   = Array(params[:products]).reject   { |p| p == 'all' || p.blank? }
    cities     = Array(params[:cities]).reject     { |c| c == 'all' || c.blank? }

    banned_docs  = Banned.pluck(:document)
    winner_docs  = Winner.joins(:participant).pluck('participants.document').uniq
    excluded_docs = (banned_docs + winner_docs).uniq

    participants = Participant
                   .where.not(document: [nil, '', *excluded_docs])
                   .joins(:participations)
                   .distinct

    participants = participants.where(city_id: cities) if cities.any?

    # Filtrado por productos a través de participations.code.product_id
    if products.any?
      participants = participants.joins(participations: { code: :product })
                                 .where(products: { id: products })
    end

    # Filtrado por categorías a través de participations.code.product.category_id
    if categories.any?
      participants = participants.joins(participations: { code: { product: :category } })
                                 .where(categories: { id: categories })
    end

    render json: { count: participants.count }
  end

  def index
    respond_to do |format|
      format.html do
        @q = Winner.ransack(params[:q])
        @q.sorts = 'created_at desc' if @q.sorts.empty?

        result = @q.result.includes(:participant).order('created_at desc')
        @pagy, @winners = pagy(result, items: (params[:limit] || 25).to_i)

        render :index
      end

      format.xlsx do
        @winners = Winner.includes(:participant).order(created_at: :desc)
        response.headers['Content-Disposition'] = 'attachment; filename=ganadores.xlsx'

        render :index
      end
    end
  end

  def show
    return if current_admin.can('winner', 'read')

    redirect_to dashboards_ecommerce_path, notice: 'Permisos insuficientes para esta operación'
    nil
  end

  def edit
    return if current_admin.can('winner', 'update')

    redirect_to dashboards_ecommerce_path, notice: 'Permisos insuficientes para esta operación'
    nil
  end

  def create
    unless current_admin.can('winner', 'create')
      redirect_to dashboards_ecommerce_path, notice: 'Permisos insuficientes para esta operación'
      return
    end
    @winner = Winner.new(winner_params)

    respond_to do |format|
      if @winner.save
        format.html { redirect_to winner_url(@winner), notice: 'Winner was successfully created.' }
        format.json { render :show, status: :created, location: @winner }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @winner.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    unless current_admin.can('winner', 'update')
      redirect_to dashboards_ecommerce_path, notice: 'Permisos insuficientes para esta operación'
      return
    end
    respond_to do |format|
      if @winner.update(winner_params)
        format.html { redirect_to winner_url(@winner), notice: 'Winner was successfully updated.' }
        format.json { render :show, status: :ok, location: @winner }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @winner.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless current_admin.can('winner', 'delete')
      redirect_to dashboards_ecommerce_path, notice: 'Permisos insuficientes para esta operación'
      return
    end
    @winner.destroy

    respond_to do |format|
      format.html { redirect_to winners_url, notice: 'Winner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end

  def winner_params
    params.require(:winner).permit(:participation_id, :status)
  end
end
