# == Schema Information
#
# Table name: aliance_stores
#
#  id         :bigint           not null, primary key
#  aliance_id :bigint           not null
#  store_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class AlianceStoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
