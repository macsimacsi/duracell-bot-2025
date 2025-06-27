class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :admin_create, default: false
      t.boolean :admin_read, default: false
      t.boolean :admin_update, default: false
      t.boolean :admin_delete, default: false

      t.timestamps
    end
  end
end