# == Schema Information
#
# Table name: participations
#
#  id             :bigint           not null, primary key
#  code_str       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  code_id        :bigint
#  participant_id :bigint           not null
#
# Indexes
#
#  index_participations_on_code_id         (code_id)
#  index_participations_on_participant_id  (participant_id)
#
# Foreign Keys
#
#  fk_rails_...  (code_id => codes.id)
#  fk_rails_...  (participant_id => participants.id)
#
require "test_helper"

class ParticipationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
