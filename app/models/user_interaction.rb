class UserInteraction < ActiveRecord::Base
  NUDGE = "nudge"
  BUMP = "bump"

  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"

  validates_presence_of :from_user, :to_user
  validates_inclusion_of :interaction_type, in: [NUDGE, BUMP]
  validate :no_interactions_between_same_user

  after_create :create_activity
  after_create :notify_in_slack

  scope :unread_bumps, -> do
    where(notification_read: false, interaction_type: UserInteraction::BUMP)
  end
  scope :unread_nudges, -> do
    where(notification_read: false, interaction_type: UserInteraction::NUDGE)
  end

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
    updated_at > 1.day.ago
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

  def notify_in_slack
    # This method is for slack integration PROTOTYPE (https://trello.com/c/a4vJnG2T)
    slack_options = {webhook_url: MULTUNUS_SLACK_WEBHOOK, username: "Moveit BOT"}
    slack_client = SlackNotify::Client.new(slack_options)

    if interaction_type == UserInteraction::BUMP
      message = "#{from_user.name.capitalize} thinks you did great job by movingit today! :smiley:"
    else
      message = "Hey #{to_user.name.capitalize}, there are people who care for your health. #{from_user.name.capitalize} nudged you to get back to exercising streak :muscle:"
    end

    slack_client.notify(message, to_user.slack_user_name)
  end
end
