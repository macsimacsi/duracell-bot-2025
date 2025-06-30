# == Schema Information
#
# Table name: winners
#
#  id             :bigint           not null, primary key
#  status         :integer          default("new_")
#  used           :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  participant_id :bigint           not null
#  prize_id       :bigint
#
# Indexes
#
#  index_winners_on_participant_id  (participant_id)
#  index_winners_on_prize_id        (prize_id)
#
class Winner < ApplicationRecord
  ransack_alias :searchable_content,
                :participation_participant_full_name_or_participation_participant_document_or_participation_participant_phone_or_prize_name
  belongs_to :participant
  belongs_to :prize, optional: true

  enum status: {
    new_: 0, # not confirmed
    confirmed_: 1, # confirmed
    delivered_: 2 # delivered
  }
end
