class Entry < ActiveRecord::Base
  scope :current_month, -> do
    where("date > ? AND date < ?", Time.now.beginning_of_month, Time.now.end_of_month)
  end

  validates :date, :duration, presence: true

  belongs_to :user

  before_save :update_amount_contribution

  private

  def update_amount_contribution
    self.amount_contributed = capped_duration * AMOUNT_PER_MINUTE
  end

  def capped_duration
    (duration > DURATION_LIMIT_FOR_CONTRIBUTION)? DURATION_LIMIT_FOR_CONTRIBUTION : duration
  end

end
