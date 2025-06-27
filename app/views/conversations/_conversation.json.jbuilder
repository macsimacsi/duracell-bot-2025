json.extract! conversation, :id, :contact, :last_message_id, :participant_id, :last_message_at, :source_id, :created_at, :updated_at
json.url conversation_url(conversation, format: :json)
