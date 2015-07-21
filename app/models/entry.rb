class Entry < ActiveRecord::Base
  scope :current_month, -> do
    where("date >= ? AND date <= ?", Time.now.beginning_of_month, Time.now.end_of_month).order("date DESC")
  end

  validates :date, :duration, presence: true

  belongs_to :user

  before_save :update_amount_contribution
  after_create :create_activity


  def fetch_timeline_json
    {
      id: id,
      from_email: user.email,
      from_name: user.name.titleize,
      gravatar_url: user.gravatar_url,
      created_at:  date,
      amount_contributed: amount_contributed,
      description: description,
      duration: duration,
      workout_image_url: workout_image_url
    }
  end

  def fetch_time_since_activity
    date
  end

  private

  def update_amount_contribution
    self.amount_contributed = capped_duration * AMOUNT_PER_MINUTE
  end

  def capped_duration
    (duration > DURATION_LIMIT_FOR_CONTRIBUTION)? DURATION_LIMIT_FOR_CONTRIBUTION : duration
  end

  def create_activity
    Activity.create(
      subject: self,
      user: user,
      target_user_id: nil
      )
  end

end
