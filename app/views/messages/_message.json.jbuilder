json.extract! message, :id, :contenu, :created_at, :updated_at
json.url message_url(message, format: :json)
