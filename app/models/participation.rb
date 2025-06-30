# == Schema Information
#
# Table name: participations
#
#  id             :bigint           not null, primary key
#  code_str       :string
#  local_str      :string
#  product_qty    :integer
#  receipt        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  code_id        :bigint
#  participant_id :bigint           not null
#  product_id     :bigint
#
# Indexes
#
#  index_participations_on_code_id         (code_id)
#  index_participations_on_participant_id  (participant_id)
#  index_participations_on_product_id      (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class Participation < ApplicationRecord
  ransack_alias :searchable_content, :full_name_or_participant_contact_or_quantity_or_document_or_gas_station_name

  belongs_to :participant, counter_cache: true
  belongs_to :product, counter_cache: true, optional: true

  has_one_attached :image, dependent: :destroy
end
