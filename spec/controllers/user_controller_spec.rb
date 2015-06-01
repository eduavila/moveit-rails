require 'rails_helper'

RSpec.describe UserController, :type => :controller do

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
end