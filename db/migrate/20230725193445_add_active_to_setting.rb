class AddActiveToSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :active, :boolean, default: false
  end
end
