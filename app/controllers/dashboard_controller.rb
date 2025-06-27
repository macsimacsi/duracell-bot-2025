class DashboardController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
    redirect_to dashboard_path
  end

  def dashboard
    chart_data
    #states_table

    # Participants
    @total_participants = Participant.count
    @users_with_most_participations = Participant.order(participations_count: :desc).limit(10)

    # Participations
    @total_participations = Participation.count
    @total_participations_today = Participation.where(created_at: Time.zone.today.all_day).count

    @state_stats = State
    .left_joins(:participants)
    .left_joins(participants: :participations)
    .group("states.id", "states.name")
    .select(
      "states.id AS state_id",
      "states.name AS state_name",
      "COUNT(DISTINCT participants.id) AS participants_count",
      "COUNT(participations.id) AS participations_count"
    )
    .order("participants_count DESC")
  end

  private

  def chart_data
    @chart_data = {
      by_day_data: Participation.group_by_day(:created_at, range: [], time_zone: 'America/Asuncion')
                                .count.transform_keys { |date| date.strftime('%d/%m') },

      by_age_data: {
        "18–25" => Participant.where(participants: { age: 18..25 }).count,
        "26–35" => Participant.where(participants: { age: 26..35 }).count,
        "36–50" => Participant.where(participants: { age: 36..50 }).count,
        "51+"   => Participant.where('participants.age > 50').count
      }
    }
  end

  def states_table
    @participants_by_state = Participant.group(:state_id).count

    @state_participants_table = @participants_by_state.map do |state_id, count|
      state_name = State.find_by(id: state_id)&.name || 'Desconocido'
      { name: state_name, count: count }
    end

    @state_stats = State
    .left_joins(:participants)
    .left_joins(participants: :participations)
    .group("states.id", "states.name")
    .select(
      "states.name AS state_name",
      "COUNT(DISTINCT participants.id) AS participants_count",
      "COUNT(participations.id) AS participations_count"
    )
    .order("participants_count DESC")
  end
end
