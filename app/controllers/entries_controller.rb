class EntriesController < ApiController

	def create
		@user = User.find_by_email(params["email"])
		if @user.blank?
			render json: {error: "User does not exist"}, status: :unauthorized
		else
			@entry = Entry.find_or_initialize_by(entry_params)
			if @entry.save
				render json: @entry, status: :created
			else
				render json: {error: "Wrong data for entry"}, status: :unprocessable_entity
			end
		end
	end

	private

	def entry_params
		params.require(:entry).permit(:date, :user_id, :duration)
	end
end
