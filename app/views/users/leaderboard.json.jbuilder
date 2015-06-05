monthly_total = 0;
json.leaderboard  @entries do |entry|
  json.email entry.user.email
  json.name entry.user.name.titleize
  json.gravatar entry.user.gravatar_url
  json.amount entry.total_amount_contributed
  json.duration entry.total_duration
  monthly_total += entry.total_amount_contributed
end
json.monthly_goal  MONTHLY_GOAL
json.monthly_total_amount monthly_total