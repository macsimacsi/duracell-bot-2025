# == Schema Information
#
# Table name: prizes
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  name       :string           not null
#  position   :integer          default(999)
#  quantity   :integer          not null
#  step       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Prize < ApplicationRecord
    ransack_alias :searchable_content, :name
    # has_many :gas_station_details
    has_many :winners
    validates :name,:quantity, presence: true
    scope :ordered, -> { order(position: :asc)}
    scope :actives, -> {where(active: true).where("step>=0")}
    validates_numericality_of :quantity, greater_than_or_equal_to: ->(prize) {prize.used}
    def used
        self.winners.count
    end
    
    def stock
        # obtiene el stock consultando la base de datos en la tabla detalles
        stock = self.quantity - self.used
        stock
    end
    # def query_quantity
    #     # obtiene quantity consultando la base de datos en la tabla detalles
    #     quantity=0
    #     self.gas_station_details.each do |gs|
    #         quantity+=gs.quantity
    #     end
    #     quantity
    # end
end
