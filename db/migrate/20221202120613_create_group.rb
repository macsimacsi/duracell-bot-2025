class CreateGroup < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :quantity, default:1

      t.timestamps
    end
  end
end
