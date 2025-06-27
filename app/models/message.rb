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
class Message < ApplicationRecord
  belongs_to :conversation

  after_create :save_last_message_id

  validates :uuid, uniqueness: true, presence: true

  private

  def save_last_message_id
    conversation.update_columns(last_message_id: id, last_message_at: created_at)
  end
end
