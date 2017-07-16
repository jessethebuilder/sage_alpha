json.extract! mail_image_request, :id, :type, :complete, :completed_at, :created_at, :updated_at
json.url mail_image_request_url(mail_image_request, format: :json)
if mail_image_request.completed_at
  json.formatted_completed_at mail_image_request.completed_at.strftime(ENV['DATETIME_DISPLAY_FORMATTER']);
end
