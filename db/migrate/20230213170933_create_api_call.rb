class CreateApiCall < ActiveRecord::Migration[6.1]
  def change
    create_table :api_calls do |t|
      t.string :url
      t.string :response_code
      t.integer :response_time
      t.integer :method
      t.text :data
      t.text :response_data
      t.bigint :response_size
      t.integer :origin

      t.timestamps
    end
  end
end
