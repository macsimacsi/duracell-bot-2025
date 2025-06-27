# == Schema Information
#
# Table name: company_states
#
#  id         :bigint           not null, primary key
#  company_id :bigint           not null
#  state_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class CompanyStateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
