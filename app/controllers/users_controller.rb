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
    render nothing: true
  end

  private

  def user_params
    params.require(:user).permit(:name,:email)
  end


end
