class CreateParticipation < ActiveRecord::Migration[6.1]
  def change
    create_table :participations do |t|
      t.references :participant, null: false, foreign_key: true
      t.text :img_path
      t.text :full_name
      t.string :document
      t.decimal :quantity
      t.integer :status, default:0
      t.references :city, nil: true, foreign_key: true, default:nil
      t.references :gas_station, nil: true, foreign_key: true, default:nil
      t.references :product, nil: true, foreign_key: true, default:nil

      t.timestamps
    end
  end
end
