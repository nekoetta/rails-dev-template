json.extract! user, :id, :name, :adress, :created_at, :updated_at
json.url user_url(user, format: :json)
