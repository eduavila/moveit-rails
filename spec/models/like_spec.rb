require "rails_helper"

RSpec.describe Like, :type => :model do
	let(:from_user) { FactoryGirl.create(:user) }
	let(:entry) {FactoryGirl.create(:entry)}
	describe 'creation of like' do
		it 'with entry details' do
			like = Like.new({entry_id: entry.id, from_user: from_user} )
			expect(like.entry_id).to eq(entry.id)
		end
		it "should belong to an entry" do 
			like = Like.create(entry_id: entry.id, from_user: from_user)
			expect(like.entry).to eq entry
		end
		it "should have interaction type as LIKE by default" do 
			like = Like.create(entry_id: entry.id, from_user: from_user)
			expect(like.interaction_type).to eq UserInteraction::LIKE
		end
		it "should save entry owner as to_user" do 
			like = Like.create(entry_id: entry.id, from_user: from_user)
			expect(like.to_user.id).to eq entry.user_id
		end
	end
end