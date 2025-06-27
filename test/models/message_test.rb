# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  body            :string
#  kind            :string
#  response        :string
#  uuid            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :bigint
#
# Indexes
#
#  index_messages_on_uuid  (uuid) UNIQUE
#
require "test_helper"

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
