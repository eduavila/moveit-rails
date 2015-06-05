require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user){create(:user)}

  describe "activity_status" do
    let!(:last_activity) { create(:entry, user: user, date: Time.now) }
    it "returns active if user has entry in less than one day" do
      allow(Entry).to receive_message_chain(:order, :limit, :first).and_return(last_activity)
      expect(user.activity_status).to eq "active"
    end

    it "retuns inactive if user has no entry in more than 2 days" do
      allow_any_instance_of(Entry).to receive(:created_at).and_return(2.days.ago)
      expect(user.activity_status).to eq "inactive"
    end
  end

  
  describe 'interaction_for' do
    before do
      @from_user = FactoryGirl.create(:user)
      @to_user = FactoryGirl.create(:user)
    end
    context "user interacted for last activity" do
      before do
        allow(@from_user).to receive(:interacted_for_last_activity?).and_return(false)
      end
      it "returns activity status if user is bumpable/nudgeble" do
        allow(@to_user).to receive(:interactable?).and_return(true)
        allow(@to_user).to receive(:activity_status).and_return("active")
        expect(@from_user.interaction_for(@to_user)).to eq "active"
      end

      it "returns activity status if user is bumpable/nudgeble" do
        allow(@to_user).to receive(:interactable?).and_return(false)
        allow(@to_user).to receive(:activity_status).and_return("something")
        expect(@from_user.interaction_for(@to_user)).to be_nil
      end

      it "#nudge_non_interactable?: returns true if a nudge was performed in last 1.day" do
        @nudge = FactoryGirl.create(:user_interaction, :nudge)
        expect(@from_user.nudge_non_interactable?(@nudge)).to be_truthy
      end

      it "#nudge_non_interactable?: returns false if nudge was performed before 1 day" do
        @nudge = FactoryGirl.create(:user_interaction, :nudge, :created_at => Time.now - 2.days)
        expect(@from_user.nudge_non_interactable?(@nudge)).to be_truthy
      end

      it "returns false if there are no user interaction activity" do
        expect(@from_user.interacted_for_last_activity?(@to_user)).to be_falsy
      end
    end

    context "user not interacted today" do
      before do
        allow(@from_user).to receive(:interacted_for_last_activity?).and_return(true)
      end
      it "returns activity status if user is bumpable/nudgeble" do
        allow(@to_user).to receive(:activity_status).and_return("active")
        expect(@from_user.interaction_for(@to_user)).to be_nil
      end

      it "returns activity status if user is bumpable/nudgeble" do
        allow(@to_user).to receive(:interactable?).and_return(false)
        allow(@to_user).to receive(:activity_status).and_return("something")
        expect(@from_user.interaction_for(@to_user)).to be_nil
      end
    end
  end
end
