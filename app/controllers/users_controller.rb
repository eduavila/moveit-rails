class UsersController < ApiController

  def create
    @user = User.create_with(user_params).find_or_create_by(email: user_params[:email])
  end

  def leaderboard
    month = params[:month]

    if month.blank?
      render json: {error: "Month parameter should be sent"}, status: :unprocessable_entity 
    else
      start_of_month = Time.parse(month).beginning_of_month
      end_of_month = Time.parse(month).end_of_month

      @entries = Entry.where('date >= ? AND date < ?', start_of_month, end_of_month)
        .select("sum(duration) as total_duration, sum(amount_contributed) as total_amount_contributed, count(*)  as total_days, users.id as user_id")
        .joins(:user).group("users.id").order("SUM(amount_contributed) desc")
    end
  end

  def monthly_summary
    @user = User.find_by email: params[:email]
    if @user
      @entries = @user.entries.current_month
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def timeline_feed
    @user = User.find_by email: params[:email]
    if @user
      @timeline_activities = Activity.fetch_activities_for_user(@user)  
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,:email)
  end

end
