# == Schema Information
#
# Table name: hours
#
#  id         :bigint           not null, primary key
#  program_id :bigint           not null
#  day        :integer
#  from       :time
#  to         :time
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class HourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
