class Like < UserInteraction
	belongs_to :entry
	after_initialize :set_interaction_type
	after_initialize :set_entry_owner_as_to_user

	private
	def set_interaction_type
		self.interaction_type = UserInteraction::LIKE
	end

	def set_entry_owner_as_to_user
		self.to_user = Entry.find(self.entry_id).user
	end

end