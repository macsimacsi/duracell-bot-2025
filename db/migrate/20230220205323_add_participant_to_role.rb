class AddParticipantToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :participant_read, :boolean
    add_column :roles, :participant_create, :boolean
    add_column :roles, :participant_update, :boolean
    add_column :roles, :participant_delete, :boolean
  end
end
