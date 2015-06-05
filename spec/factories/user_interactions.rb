FactoryGirl.define do
  factory :user_interaction do
    from_user {FactoryGirl.create(:user)}
    to_user {FactoryGirl.create(:user)}

    trait :bump do
      interaction_type UserInteraction::BUMP
    end

    trait :nudge do
      interaction_type UserInteraction::NUDGE
    end

    trait :read do
      notification_read true
    end
  end

end
