class NotificationsController < ApiController
  def message
  	@time = "#{params['time']}oClock"
  	@user = User.find_by email: params[:email]
  	@unread_bumps_count = UserInteraction.where(from_user: @user).unread_bumps.count
  	@unread_nudges_count = UserInteraction.where(from_user: @user).unread_nudges.count
  end

  def read
  	@user = User.find_by email: params[:email]
  	unread_user_interactions = UserInteraction.where(to_user: @user, notification_read: false)
    unread_user_interactions.each do |interaction|
    	interaction.update_attributes(notification_read: true)
    end
    render json: {message: "Marked all notifications as read"}, status: :ok
  end
end
