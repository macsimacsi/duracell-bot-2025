class AddUsedToWinner < ActiveRecord::Migration[6.1]
  def change
    add_column :winners, :used, :boolean, default: false
  end
end
