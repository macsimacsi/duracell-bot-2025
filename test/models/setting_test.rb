# == Schema Information
#
# Table name: settings
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE)
#  date_end   :datetime
#  date_start :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class SettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
