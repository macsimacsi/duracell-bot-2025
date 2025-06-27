# == Schema Information
#
# Table name: roles
#
#  id                   :bigint           not null, primary key
#  admin_create         :boolean          default(FALSE)
#  admin_delete         :boolean          default(FALSE)
#  admin_read           :boolean          default(FALSE)
#  admin_update         :boolean          default(FALSE)
#  banned_create        :boolean
#  banned_delete        :boolean
#  banned_read          :boolean
#  banned_update        :boolean
#  code_create          :boolean          default(FALSE)
#  code_delete          :boolean          default(FALSE)
#  code_read            :boolean          default(FALSE)
#  code_update          :boolean          default(FALSE)
#  name                 :string
#  participant_create   :boolean
#  participant_delete   :boolean
#  participant_read     :boolean
#  participant_update   :boolean
#  participation_create :boolean
#  participation_delete :boolean
#  participation_read   :boolean
#  participation_update :boolean
#  prize_create         :boolean
#  prize_delete         :boolean
#  prize_read           :boolean
#  prize_update         :boolean
#  role_create          :boolean
#  role_delete          :boolean
#  role_read            :boolean
#  role_update          :boolean
#  state_create         :boolean          default(FALSE)
#  state_delete         :boolean          default(FALSE)
#  state_read           :boolean          default(FALSE)
#  state_update         :boolean          default(FALSE)
#  winner_create        :boolean
#  winner_delete        :boolean
#  winner_read          :boolean
#  winner_update        :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "test_helper"

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
