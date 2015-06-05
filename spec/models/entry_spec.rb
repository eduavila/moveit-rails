require 'rails_helper'

RSpec.describe Entry, :type => :model do
  it "should calculate amount contributed before creating and entry" do
    user = create(:user)
    entry = create(:entry, user_id: user.id, :duration => 35)
    expect(entry.amount_contributed).to eq(150)
  end

  describe ".current_month" do
    let!(:current_month_entry) { create :entry, date: Date.today }
    let!(:prev_month_entry) { create :entry, date: Date.today - 1.month }
    let!(:next_month_entry) { create :entry, date: Date.today + 1.month }
    let!(:entry_from_next_year) { create :entry, date: Date.today + 1.year }

    it "includes entries for the current month" do
      expect(Entry.current_month).to include current_month_entry
    end

    it "does not include entries of other months" do
      expect(Entry.current_month).not_to include next_month_entry
      expect(Entry.current_month).not_to include prev_month_entry
    end

    it "does not include entries of the same month of another year" do
      expect(Entry.current_month).not_to include entry_from_next_year
    end

  end
end
