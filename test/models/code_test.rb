# == Schema Information
#
# Table name: codes
#
#  id         :bigint           not null, primary key
#  used       :boolean          default(FALSE), not null
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :bigint           not null
#  user_id    :bigint
#
# Indexes
#
#  index_codes_on_product_id  (product_id)
#  index_codes_on_used        (used)
#  index_codes_on_value       (value) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
require "test_helper"

class CodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
