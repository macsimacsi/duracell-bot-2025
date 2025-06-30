# == Schema Information
#
# Table name: participants
#
#  id                   :bigint           not null, primary key
#  age                  :integer          default(0), not null
#  contact              :string
#  document             :string
#  full_name            :string
#  genre                :integer          default(3), not null
#  opt_out              :boolean          default(FALSE), not null
#  participations_count :integer          default(0), not null
#  received_template    :boolean          default(FALSE)
#  status               :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  state_id             :bigint
#
# Indexes
#
#  index_participants_on_age       (age)
#  index_participants_on_state_id  (state_id)
#
class Participant < ApplicationRecord
  ransack_alias :searchable_content, :full_name_or_contact
  has_many :participations, dependent: :delete_all
  belongs_to :state, optional: true
  has_one :winner
end
