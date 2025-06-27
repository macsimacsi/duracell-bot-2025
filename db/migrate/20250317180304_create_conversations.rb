class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.string :contact
      t.bigint :last_message_id
      t.bigint :participant_id
      t.datetime :last_message_at
      t.string :source_id

      t.timestamps
    end
    add_index :conversations, :contact, unique: true
  end
end
