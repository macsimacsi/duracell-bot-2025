class AddGenreToParticipant < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :genre, :integer, null: false, default: 3
    # Enumeración para el género
    # 0 Femenino
    # 1 Masculino
    # 2 Prefiero no decir
    # 3 Otro
  end
end
