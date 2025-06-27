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
class GasStationDetail < ApplicationRecord
  belongs_to :gas_station
  belongs_to :prize

  validates :quantity, presence: true
  before_update do
    if self.quantity_changed?
      remain= self.quantity_was - self.quantity
      self.stock -= remain
      prize=Prize.find(self.prize_id)
      prize.quantity -= remain
      prize.save

    end
  end
end
