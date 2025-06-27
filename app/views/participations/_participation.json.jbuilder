json.extract! participation, :id, :participant_id, :img_path, :full_name, :document, :quantity, :status, :city_id, :gas_station_id, :product_id, :created_at, :updated_at
json.url participation_url(participation, format: :json)
