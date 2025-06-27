class AddStatIdToCities < ActiveRecord::Migration[6.1]
  def change
    add_reference :cities, :state, null: false, foreign_key: true
  end
end
