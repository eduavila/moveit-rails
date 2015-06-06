json.notifications @notifications do |activity|
	json.id activity.id
	json.activity_type activity.subject_type
	json.activity_json_data activity.subject.fetch_timeline_json
	json.time_since_in_words distance_of_time_in_words(Time.now, activity.subject.created_at)
end