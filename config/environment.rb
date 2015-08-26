# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

AMOUNT_PER_MINUTE = 5 # indian rupees
DURATION_LIMIT_FOR_CONTRIBUTION = 30 # minutes
MONTHLY_GOAL = 33000 # indian rupees