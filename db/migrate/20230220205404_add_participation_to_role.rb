class AddParticipationToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :participation_read, :boolean
    add_column :roles, :participation_create, :boolean
    add_column :roles, :participation_update, :boolean
    add_column :roles, :participation_delete, :boolean
  end
end
