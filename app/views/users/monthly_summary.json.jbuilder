json.user do
  json.name @user.name
  json.email @user.email
  json.gravatar_url @user.gravatar_url
  json.monthly_summary @entries
end
