class AddBranchesToParticipation < ActiveRecord::Migration[6.1]
  def change
    add_column :participations, :branch, :string
  end
end
