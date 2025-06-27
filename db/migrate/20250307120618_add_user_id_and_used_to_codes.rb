class AddUserIdAndUsedToCodes < ActiveRecord::Migration[6.1]
  def change
    add_column :codes, :user_id, :bigint
    add_column :codes, :used, :boolean, default: false, null: false
  end
end
