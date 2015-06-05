class Activity < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :user

  def self.fetch_activities_for_user(user)
    Activity.where("target_user_id IS NULL or target_user_id=?", user.id)
    .order("created_at DESC")
  end
end
