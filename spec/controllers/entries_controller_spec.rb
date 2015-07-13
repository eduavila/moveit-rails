require 'rails_helper'

RSpec.describe EntriesController, :type => :controller do
  render_views

  let!(:user){
    create(:user)
  }

  let(:entry_params){{email: user.email,entry: FactoryGirl.attributes_for(:entry,user_id:user.id)}}

  describe "POST #create" do

    it "create entry with valid data" do
      expect do
        post :create, entry_params
      end.to change(Entry, :count).by(1)
      expect(response).to have_http_status(:created)

      responseData = JSON.parse(response.body)
      expect(responseData["user_id"]).to eq(user.id)
      expect(responseData["description"]).not_to be_empty
    end

    it "updates entry if same date" do
      todays_entry = create(:entry, user: user)
      entry_params[:entry][:duration] = 30
      expect do
        post :create, entry_params
      end.to change(Entry, :count).by(0)
      expect(response).to have_http_status(:created)

      responseData = JSON.parse(response.body)
      expect(responseData["user_id"]).to eq(user.id)
      expect(responseData["duration"]).to eq(30)
    end

    it "fail when invalid data" do
      expect do
        post :create, {email: user.email, entry: {date: Time.now}}, format: :json
      end.to change(Entry, :count).by(0)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "fail when unauthorized" do
      entry_params = {
        date: Time.now,
        user_id: user.id,
        duration: 35
      }
      expect do
        post :create, {email: "nonexistent_user_email@gmail.com", entry: entry_params}, format: :json
      end.to change(Entry, :count).by(0)
      expect(response).to have_http_status(:unauthorized)
    end
  end

end
