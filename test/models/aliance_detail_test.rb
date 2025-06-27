# == Schema Information
#
# Table name: aliance_details
#
#  id                     :bigint           not null, primary key
#  aliance_id             :bigint           not null
#  coupons                :integer          not null
#  value_per_coupon       :decimal(10, )    not null
#  conditions             :text(65535)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  minimum_purchase_value :decimal(12, )    not null
#
require "test_helper"

class AlianceDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
