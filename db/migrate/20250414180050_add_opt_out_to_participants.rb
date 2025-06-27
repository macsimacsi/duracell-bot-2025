class AddOptOutToParticipants < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :opt_out, :boolean, default: false, null: false
  end
end
