# == Schema Information
#
# Table name: products
#
#  id                   :bigint           not null, primary key
#  active               :boolean          default(TRUE)
#  name                 :string
#  participations_count :integer
#  qty                  :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Product < ApplicationRecord
  belongs_to :participation, optional: true

  scope :active, -> { where(active: true).order(id: :asc) }
end
