class AddPrizeToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :prize_create, :boolean
    add_column :roles, :prize_read, :boolean
    add_column :roles, :prize_update, :boolean
    add_column :roles, :prize_delete, :boolean
  end
end
