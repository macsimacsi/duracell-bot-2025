class AddIndexUniqueToCode < ActiveRecord::Migration[6.1]
  def change
    add_index :codes, :value, unique: true
  end
end
