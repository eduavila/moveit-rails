class UserController < ApiController

  def create
    @user = User.create_with(user_params).find_or_create_by(email: user_params[:email])
  end

  private

  def user_params
    params.require(:user).permit(:name,:email)
  end
end
