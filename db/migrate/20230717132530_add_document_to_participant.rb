class AddDocumentToParticipant < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :document, :string
  end
end
