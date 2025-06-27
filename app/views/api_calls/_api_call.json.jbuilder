json.extract! api_call, :id, :url, :response_code, :response_time, :created_at, :updated_at
json.url api_call_url(api_call, format: :json)
