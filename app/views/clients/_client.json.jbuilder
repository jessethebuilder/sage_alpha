json.extract! client, :id, :email, :keywords, :created_at, :updated_at
json.url client_url(client, format: :json)
