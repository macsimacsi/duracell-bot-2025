# == Schema Information
#
# Table name: aliance_gas_stations
#
#  id             :bigint           not null, primary key
#  aliance_id     :bigint           not null
#  gas_station_id :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "test_helper"

class AlianceGasStationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
