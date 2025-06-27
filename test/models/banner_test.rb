# == Schema Information
#
# Table name: banners
#
#  id         :bigint           not null, primary key
#  link       :string(255)
#  active     :boolean          default(FALSE)
#  position   :integer          default(1000)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class BannerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
