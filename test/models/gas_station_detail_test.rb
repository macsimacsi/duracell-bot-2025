# == Schema Information
#
# Table name: gas_station_details
#
#  id             :bigint           not null, primary key
#  quantity       :integer          not null
#  stock          :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  gas_station_id :bigint           not null
#  prize_id       :bigint           not null
#
# Indexes
#
#  index_gas_station_details_on_gas_station_id  (gas_station_id)
#  index_gas_station_details_on_prize_id        (prize_id)
#
# Foreign Keys
#
#  fk_rails_...  (gas_station_id => gas_stations.id)
#  fk_rails_...  (prize_id => prizes.id)
#
require "test_helper"

class GasStationDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
