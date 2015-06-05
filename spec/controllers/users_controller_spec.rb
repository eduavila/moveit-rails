require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  render_views

  let!(:user) {FactoryGirl.create(:user)}
  let!(:entry1) {FactoryGirl.create(:entry,user_id: user.id )}
  let!(:entry2) {FactoryGirl.create(:second_entry,user_id: user.id)}

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

    it "orders by highet contributer first order" do
      user_2 = create(:user)
      create(:entry,user_id: user_2.id, duration: 30)
      create(:entry,user_id: user_2.id, duration: 30)

      get :leaderboard, month: "#{Date::MONTHNAMES[Time.now.month]} #{Time.now.year}", format: :json
      data = JSON.parse(response.body)

      expect_user_order = [user_2.email, user.email]
      expect(data["leaderboard"].map{|users_data| users_data["email"]}).to eq(expect_user_order)
    end

    it "fails if month parameter is absent" do
       get :leaderboard, invalid_param: " ", format: :json
       expect(response).to have_http_status(:unprocessable_entity)
    end
  end


  describe "GET monthly report" do
    it "fetches all entries for current month of the given user" do
      get :monthly_summary, email: user.email, format: :json

      responseData = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(responseData[0]["duration"]).to eq(entry1.duration)
      expect(responseData[0]["amount_contributed"]).to eq(entry1.amount_contributed)
    end

    it "does not include entries of a different user" do
      create :entry

      get :monthly_summary, email: user.email, format: :json

      responseData = JSON.parse(response.body)

      expect(responseData.length).to eq 2
    end

    it "responds with a 401 if user does not exist" do
      get :monthly_summary, email: "some_email", format: :json

      expect(response).to have_http_status :not_found
    end
  end

end
