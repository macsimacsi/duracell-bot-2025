class RemoveColumnsFromParticipants < ActiveRecord::Migration[6.1]
  def change
    remove_column :participants, :quantity
  end
end
