class AddWinnersToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :winner_read, :boolean
    add_column :roles, :winner_create, :boolean
    add_column :roles, :winner_update, :boolean
    add_column :roles, :winner_delete, :boolean
  end
end
