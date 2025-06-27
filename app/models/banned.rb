# == Schema Information
#
# Table name: banneds
#
#  id         :bigint           not null, primary key
#  document   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Banned < ApplicationRecord
  ransack_alias :searchable_content, :document
end
