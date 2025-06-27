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
class Setting < ApplicationRecord
    after_save :leave_one_active

    private
    def leave_one_active
        Setting.where.not(id: self.id).update_all(active: false)
    end
end
