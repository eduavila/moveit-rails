require 'rails_helper'

RSpec.describe EntriesController, :type => :controller do

	render_views

	describe "POST #create" do
		let!(:user_1){
			create(:user)
		}
		let!(:user_2){
			create(:user)
		}

		it "create entry with valid data" do
			entry_params = {
				email: user_1.email,
				entry: {
					date: Time.now,
					user_id: user_1.id,
					duration: 35
				}, :format => "json" 
			}
			expect do
				post :create, entry_params
			end.to change(Entry, :count).by(1)
			expect(response).to have_http_status(:created)

			responseData = JSON.parse(response.body)
			expect(responseData["user_id"]).to eq(user_1.id)
		end

		it "fail when invalid data" do 
			expect do
				post :create, {email: user_1.email, entry: {date: Time.now}}, format: :json
			end.to change(Entry, :count).by(0)
			expect(response).to have_http_status(:unprocessable_entity)
		end

	 	it "fail when unauthorized" do
	 		entry_params = {
	 			date: Time.now,
	 			user_id: user_1.id,
	 			duration: 35
			}
	 		expect do
				post :create, {email: "nonexistent_user_email@gmail.com", entry: entry_params}, format: :json
			end.to change(Entry, :count).by(0)
			expect(response).to have_http_status(:unauthorized)
	 	end
	end
end