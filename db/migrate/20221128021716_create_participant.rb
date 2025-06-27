class CreateParticipant < ActiveRecord::Migration[6.1]
  def change
    create_table :participants do |t|
      t.string :full_name
      t.string :contact
      t.decimal :quantity
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
