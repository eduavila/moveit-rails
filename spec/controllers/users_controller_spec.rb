require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  render_views

  describe "#create" do

    let(:user_params) do
      {
        user: {
          name: "John Doe",
          email: "john.doe@email.com"
        },
        :format => "json"
      }
    end

    it "creates a new user record" do
      expect do
        post :create, user_params
      end.to change(User, :count).by(1)
    end

    it "returns the user data" do
      post :create, user_params
      expect(response.status).to eq(200)

      responseData = JSON.parse(response.body)
      expect(responseData["user"]["name"]).to eq(user_params[:user][:name])
    end

    it "returns the user data without creating a duplicate" do
      create(:user, user_params[:user])
      expect do
        post :create, user_params
      end.to change(User, :count).by(0)
    end
  end

  context "GET #leaderboard" do

    let!(:user) {FactoryGirl.create(:user)}
    let!(:entry1) {FactoryGirl.create(:entry,user_id: user.id )}
    let!(:entry2) {FactoryGirl.create(:second_entry,user_id: user.id)}

    it "calculates the total duration for the user" do
      get :leaderboard, month: "#{Date::MONTHNAMES[Time.now.month]} #{Time.now.year}", format: :json

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(data).to eq({
        "leaderboard" => [
          {
            "email" => user.email,
            "name" => user.name.titleize,
            "amount" => (entry1.duration + entry2.duration)*5,
            "duration" => entry1.duration + entry2.duration
          }
        ],
        "monthly_goal" => MONTHLY_GOAL,
        "monthly_total_amount" => (entry1.amount_contributed + entry2.amount_contributed)
      })
    end


  end

end