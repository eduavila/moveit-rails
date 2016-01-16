class UsersController < ApiController
  helper ApplicationHelper

  def create
    @user = User.create_with(user_params).find_or_create_by(email: user_params[:email])
    render json: @user.to_json(root:true, methods: [:gravatar_url])
  end

  def interaction
    from_user = User.find_by_email(params[:from_email_id])
    to_user = User.find_by_email(params[:to_email_id])
    @user_interaction = UserInteraction.create(from_user: from_user, to_user: to_user, interaction_type: params[:interaction_type])

    if @user_interaction
      render json: @user_interaction, status: :created
    end
  end

  def leaderboard
    month = params[:month]

    if month.blank?
      render json: {error: "Month parameter should be sent"}, status: :unprocessable_entity
    else
      start_of_month = Time.parse(month).beginning_of_month
      end_of_month = Time.parse(month).end_of_month
      @user = User.find_by_email(params[:email])
      @entries = Entry.where('date >= ? AND date <= ?', start_of_month, end_of_month)
        .select("sum(duration) as total_duration, sum(amount_contributed) as total_amount_contributed, count(*)  as total_days, users.id as user_id")
        .joins(:user).group("users.id").order("SUM(amount_contributed) desc")

      user_ids_with_entries = @entries.map {|entry| entry.user.id}
      @users_without_entries = User.from_multunus.where("id NOT in (?)", user_ids_with_entries)
    end
  end

  def monthly_summary
    month = params[:month]
    @user = User.find_by email: params[:email]
    if @user
      if month.blank?
        @entries = @user.entries.current_month
      else
        @entries = @user.entries.during_month(month)
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def timeline_feed
    @user = User.find_by email: params[:email]
    if @user
      @timeline_activities = Activity.by_workout_type.for_user(@user).limit(100)
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,:email)
  end

end
