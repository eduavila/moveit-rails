require 'rails_helper'

RSpec.describe UserController, :type => :controller do

  render_views
  let(:json) { JSON.parse(response.body) }

  describe "#create" do

    let(:user_params) do
      {
        user: {
          name: "John Doe",
          email: "john.doe@email.com"
        }
      }
    end

    it "creates a new user record" do
      initial_count = User.count
      post :create, user_params
      expect(User.count).to be > initial_count
    end

    it "returns the user data" do
      post :create, user_params
      response.should render_template("user")
    end

    it "returns the user data without creating a duplicate" do
      User.create(name: "John Doe", email: "john.doe@email.com")
      initial_count = User.count
      post :create, user_params
      expect(User.count).to eq initial_count
      response.should render_template("user")
    end
  end
end