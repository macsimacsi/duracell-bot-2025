json.extract! participant, :id, :full_name, :contact, :is_winner, :quantity, :created_at, :updated_at
json.url participant_url(participant, format: :json)
