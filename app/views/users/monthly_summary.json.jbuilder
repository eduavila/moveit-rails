json.user do
  json.name @user.name
  json.gravatar_url @user.gravatar_url
  json.monthly_summary @entries
end
