class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.bigint :conversation_id
      t.string :body
      t.string :response
      t.string :kind
      t.string :uuid

      t.timestamps
    end
    add_index :messages, :uuid, unique: true
  end
end
