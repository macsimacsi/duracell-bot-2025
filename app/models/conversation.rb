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
class Conversation < ApplicationRecord
  ransack_alias :search, :contact

  belongs_to :last_message, class_name: 'Message', optional: true
  has_many :messages

  validates :contact, uniqueness: true, presence: true

  def to_param
    contact
  end
end
