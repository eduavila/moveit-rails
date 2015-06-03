class Entry < ActiveRecord::Base
	validates_presence_of :date
	validates_presence_of :duration

	belongs_to :user

	before_save :update_amount_contribution 


	private
	def update_amount_contribution 
		self.amount_contributed = capped_duration * AMOUNT_PER_MINUTE
	end

	def capped_duration
		(duration > DURATION_LIMIT_FOR_CONTRIBUTION)? DURATION_LIMIT_FOR_CONTRIBUTION : duration
	end

end
