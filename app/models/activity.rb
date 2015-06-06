class Activity < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :user
  
  scope :for_user, -> (user) {
  	where("target_user_id IS NULL or target_user_id=?", user.id)
    .order("created_at DESC")
  }

  scope :by_user_interaction_type, -> do 
  	where(subject_type: "UserInteraction")
  end
end
