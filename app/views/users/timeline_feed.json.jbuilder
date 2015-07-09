json.timeline_activities @timeline_activities do |activity|
	json.id activity.id
	json.activity_type activity.subject_type
	json.activity_json_data activity.subject.fetch_timeline_json
	json.time_since_in_words days_difference_in_words_in_ist(activity.subject.fetch_time_since_activity)
end