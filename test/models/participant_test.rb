# == Schema Information
#
# Table name: participants
#
#  id                   :bigint           not null, primary key
#  age                  :integer          default(0), not null
#  contact              :string
#  document             :string
#  full_name            :string
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
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
require "test_helper"

class ParticipantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
