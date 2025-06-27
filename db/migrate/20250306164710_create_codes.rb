class CreateCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :codes do |t|
      t.string :value
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
