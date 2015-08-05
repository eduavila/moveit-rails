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
      get :leaderboard,  {:email => user.email, :month => "#{Date::MONTHNAMES[Time.now.month]} #{Time.now.year}", :format => :json}

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(data).to eq({
        "leaderboard" => {
          "with_entries" => [
            {
              "email" => user.email,
              "name" => user.name.titleize,
              "gravatar" => user.gravatar_url,
              "amount" => (entry1.duration + entry2.duration)*5,
              "duration" => entry1.duration + entry2.duration,
              "activity_status"=>"active", 
              "interactable"=>"bump"
            }
          ],
          "without_entries" => []
        },
        "monthly_goal" => MONTHLY_GOAL,
        "monthly_total_amount" => (entry1.amount_contributed + entry2.amount_contributed)
      })
    end

    it "orders by highest contributer first order" do
      user_2 = create(:user)
      create(:entry,user_id: user_2.id, duration: 30)
      create(:entry,user_id: user_2.id, duration: 30)

      get :leaderboard, {:email => user.email, :month => "#{Date::MONTHNAMES[Time.now.month]} #{Time.now.year}", :format => :json}
      data = JSON.parse(response.body)

      expect_user_order = [user_2.email, user.email]
      expect(data["leaderboard"]["with_entries"].map{|users_data| users_data["email"]}).to eq(expect_user_order)
    end

    it "sets interactability for each user for user interaction" do
      user_2 = create(:user)
      get :leaderboard, {:email => user_2.email, :month => "#{Date::MONTHNAMES[Time.now.month]} #{Time.now.year}", :format => :json}
      data = JSON.parse(response.body)["leaderboard"]["with_entries"]

      expect(data[0]["interactable"]).to eq("bump")
      expect(data[0]["activity_status"]).to eq("active")
    end

    it "fails if month parameter is absent" do
       get :leaderboard, invalid_param: " ", format: :json
       expect(response).to have_http_status(:unprocessable_entity)
    end

    it "also appends all other users of Multunus" do
      new_user = create(:user)
      get :leaderboard, {:email => user.email, :month => "#{Date::MONTHNAMES[Time.now.month]} #{Time.now.year}", :format => :json}
      data = JSON.parse(response.body)["leaderboard"]
      expect(data["without_entries"][0]["email"]).to eq(new_user.email)
    end
  end


  describe "GET monthly report" do
    it "sets @user" do
      get :monthly_summary, email: user.email, format: :json

      expect(assigns(:user)).to eq user
    end

    it "sets @entries" do
      create :entry

      get :monthly_summary, email: user.email, format: :json

      expect(assigns(:entries)).to eq [entry1, entry2]
    end

    it "responds with a 401 if user does not exist" do
      get :monthly_summary, email: "some_email", format: :json

      expect(response).to have_http_status :not_found
    end

    describe "reponse" do
      before do
        get :monthly_summary, email: user.email, format: :json
      end

      it "includes the user meta data" do
        responseData = JSON.parse(response.body)
        expect(responseData["user"]["name"]).to eq user.name
        expect(responseData["user"]["gravatar_url"]).to eq user.gravatar_url
      end

      it "includes the monthly summary of the user" do
        monthly_summary = JSON.parse(response.body)["user"]["monthly_summary"]
        expect(monthly_summary[0]["duration"]).to eq(entry1.duration)
        expect(monthly_summary[0]["amount_contributed"]).to eq(entry1.amount_contributed)
      end
    end

  end

  context "GET #timeline_feed" do
    let(:from_user) { create(:user) }
    let(:to_user) { create(:user) }
    it "return workout activities" do
      workout_entry = create(:entry, created_at: "2015-05-25 00:00:00", user: user)

      get :timeline_feed, email: user.email, format: :json

      expect(response).to have_http_status :ok 
      responseData = JSON.parse(response.body)["timeline_activities"]
      expect(responseData[0]["activity_type"]).to eq "Entry"
      expect(responseData[0]["activity_json_data"]["id"]).to eq workout_entry.id    
    end

    it "not return user interaction activities" do
      interaction = create(:user_interaction, :bump, from_user: from_user, to_user: to_user)

      get :timeline_feed, email: to_user.email, format: :json

      expect(response).to have_http_status :ok 
      responseData = JSON.parse(response.body)["timeline_activities"]
      expect(responseData[0]["activity_type"]).not_to eq "UserInteraction"
      expect(responseData[0]["activity_json_data"]["id"]).not_to eq interaction.id
    end

    it "fails with a 401 if user does not exist" do
      get :timeline_feed, email: "some_email", format: :json

      expect(response).to have_http_status :not_found
    end
  end

  context "POST user interaction" do 
    let(:from_user) { create(:user) }
    let(:to_user) { create(:user) }
    context "BUMP" do 
      it "creates bump user_interaction" do
        expect do
          post :interaction, {from_email_id: from_user.email, to_email_id: to_user.email, interaction_type: "bump" }, format: :json
        end.to change(UserInteraction, :count).by(1)

        created_interaction = UserInteraction.last
        expect(created_interaction.to_user).to eq to_user  
        expect(created_interaction.from_user).to eq from_user  
        expect(created_interaction.interaction_type).to eq UserInteraction::BUMP
      end

      it "responds with bump JSON details" do
        post :interaction, {from_email_id: from_user.email, to_email_id: to_user.email, interaction_type: "bump"}, format: :json

        expect(response).to have_http_status(:created)
        responseData = JSON.parse(response.body)
        expect(responseData["interaction_type"]).to eq(UserInteraction::BUMP)
      end
    end

    context "NUDGE" do 
      it "creates nudge user_interaction" do
        expect do
          post :interaction, {from_email_id: from_user.email, to_email_id: to_user.email, interaction_type: "nudge" }, format: :json
        end.to change(UserInteraction, :count).by(1)

        created_interaction = UserInteraction.last
        expect(created_interaction.to_user).to eq to_user  
        expect(created_interaction.from_user).to eq from_user  
        expect(created_interaction.interaction_type).to eq UserInteraction::NUDGE
      end

      it "responds with nudge JSON details" do
        post :interaction, {from_email_id: from_user.email, to_email_id: to_user.email, interaction_type: "nudge"}, format: :json

        expect(response).to have_http_status(:created)
        responseData = JSON.parse(response.body)
        expect(responseData["interaction_type"]).to eq(UserInteraction::NUDGE)
      end
    end
  end
end
