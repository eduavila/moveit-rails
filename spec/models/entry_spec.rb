require 'rails_helper'

RSpec.describe Entry, :type => :model do
  it "should calculate amount contributed before creating and entry" do
  	user = create(:user)
  	entry = create(:entry, user_id: user.id, :duration => 35)
  	expect(entry.amount_contributed).to eq(150)
  end
end
