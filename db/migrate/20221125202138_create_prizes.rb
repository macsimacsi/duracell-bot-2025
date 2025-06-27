class CreatePrizes < ActiveRecord::Migration[6.1]
  def change
    create_table :prizes do |t|
      t.string :name, null: false
      t.integer :quantity, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
