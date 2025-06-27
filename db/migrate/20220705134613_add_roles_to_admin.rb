class AddRolesToAdmin < ActiveRecord::Migration[6.1]
  def change
    add_reference :admins, :role, null: false, foreign_key: true
  end
end
