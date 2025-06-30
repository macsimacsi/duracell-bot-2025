class AddQtyToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :qty, :integer
  end
end
