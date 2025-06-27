class AddReceivedTemplateToParticipant < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :received_template, :boolean, default: false
  end
end
