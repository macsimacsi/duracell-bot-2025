class AddNameToGenre < ActiveRecord::Migration[6.1]
  def change
    add_column :genres, :name, :integer
  end
end
