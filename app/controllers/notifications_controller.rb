class NotificationsController < ApiController
  def message
  	@time = "#{params['time']}oClock"
  	@user = User.find_by email: params[:email]
  	@unread_bumps_count = UserInteraction.where(from_user: @user).unread_bumps.count
  	@unread_nudges_count = UserInteraction.where(from_user: @user).unread_nudges.count
  end
end
