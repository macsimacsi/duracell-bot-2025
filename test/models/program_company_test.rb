# == Schema Information
#
# Table name: program_companies
#
#  id         :bigint           not null, primary key
#  program_id :bigint           not null
#  company_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class ProgramCompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
