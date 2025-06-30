# == Schema Information
#
# Table name: genres
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Genre < ApplicationRecord
  has_many :participants

  # Enumeración para el género
  enum name: {
    femenino: 0,
    masculino: 1,
    prefiero_no_decir: 2,
    otro: 3
  }
end
