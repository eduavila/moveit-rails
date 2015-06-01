class UserController < ApiController

  def create
    @user = User.find_or_create_by(user_params)
    render "create"
  end

  private

  def user_params
    params.require(:user).permit(:name,:email)
  end
end
