class AddUsedIndexToCode < ActiveRecord::Migration[6.1]
  def change
    add_index :codes, :used
  end
end
