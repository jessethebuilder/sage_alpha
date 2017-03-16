json.extract! mail_queue, :id, :created_at, :updated_at
json.url mail_queue_url(mail_queue, format: :json)
