# == Schema Information
#
# Table name: banneds
#
#  id         :bigint           not null, primary key
#  document   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class BannedTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
