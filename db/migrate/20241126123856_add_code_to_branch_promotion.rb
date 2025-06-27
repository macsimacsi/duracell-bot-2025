class AddCodeToBranchPromotion < ActiveRecord::Migration[6.1]
  def change
    add_column :branch_promotions, :code, :integer
  end
end
