# == Schema Information
#
# Table name: states
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class State < ApplicationRecord
  has_many :participants
  has_many :participations, through: :participants

  scope :active, -> { where(active: true) }
end
