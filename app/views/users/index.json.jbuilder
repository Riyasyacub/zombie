json.data do
  json.array! @users, partial: 'user', as: :user
end