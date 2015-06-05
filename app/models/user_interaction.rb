class UserInteraction < ActiveRecord::Base
  NUDGE = "nudge"
  BUMP = "bump"

  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"

  validates_presence_of :from_user, :to_user
  validates_inclusion_of :interaction_type, in: [NUDGE, BUMP]
  validate :no_interactions_between_same_user

  after_create :create_activity

  def fetch_timeline_json
    {
      id: id,
      email: from_user.email,
      name: from_user.name.titleize,
      gravatar_url: from_user.gravatar_url,
      created_at:  created_at,
      interaction_type: (interaction_type.to_sym.verb.conjugate :tense => :past, :aspect => :perfective),
      notification_read: notification_read.to_s
    }
  end

  def bump?
    interaction_type == BUMP
  end

  def nudge?
    interaction_type == NUDGE
  end

  def in_last_24_hours?
    updated_at > (Time.now - 1.day)
  end

  def not_in_last_24_hours?
    !(in_last_24_hours?)
  end

  private

  def no_interactions_between_same_user
    if from_user == to_user
      errors.add(:user, "cannot bump or nudge oneself")
    end
  end

  def create_activity
    Activity.create(
      subject: self,
      user_id: from_user.id,
      target_user_id: to_user.id
    )
  end
end
