# == Schema Information
#
# Table name: winners
#
#  id             :bigint           not null, primary key
#  status         :integer          default("new_")
#  used           :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  participant_id :bigint           not null
#  prize_id       :bigint
#
# Indexes
#
#  index_winners_on_participant_id  (participant_id)
#  index_winners_on_prize_id        (prize_id)
#
# Foreign Keys
#
#  fk_rails_...  (participant_id => participants.id)
#  fk_rails_...  (prize_id => prizes.id)
#
require "test_helper"

class WinnerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
