module ApplicationHelper
	def days_difference_in_ist_from_today(from_time)
		(Date.today.in_time_zone("Chennai").to_date - from_time.in_time_zone("Chennai").to_date).to_i
	end

	def days_difference_in_words_in_ist(from_time)
		days_difference = days_difference_in_ist_from_today(from_time)

		if days_difference == 0
			"today"
		elsif days_difference == 1
			"y'day"
		else
			"#{days_difference}d ago"
		end
	end
end