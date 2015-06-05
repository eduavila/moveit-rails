require 'rails_helper'

RSpec.describe UserInteraction, :type => :model do
  let(:from_user) { FactoryGirl.create(:user) }
  let(:to_user) { FactoryGirl.create(:user) }
  describe 'interaction between same user' do
    it 'doesnot create a new interaction' do
      expect(FactoryGirl.build(:user_interaction, :bump, from_user: from_user, to_user: from_user)).not_to be_valid
    end
  end

  it "should create an activity entry of subject type User UserInteraction" do
    expect {
      FactoryGirl.create(:user_interaction, :bump, from_user: from_user, to_user: to_user)
    }.to change(Activity, :count).by(1)
    a = Activity.last
    expect(a.target_user_id).to eq to_user.id
    expect(a.user_id).to eq from_user.id
  end
end
