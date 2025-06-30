class AddReceiptToParticipation < ActiveRecord::Migration[6.1]
  def change
    add_column :participations, :receipt, :integer
  end
end
