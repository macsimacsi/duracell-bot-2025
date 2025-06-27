# == Schema Information
#
# Table name: conversations
#
#  id              :bigint           not null, primary key
#  contact         :string
#  last_message_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_message_id :bigint
#  participant_id  :bigint
#  source_id       :string
#
# Indexes
#
#  index_conversations_on_contact  (contact) UNIQUE
#
require "test_helper"

class ConversationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
