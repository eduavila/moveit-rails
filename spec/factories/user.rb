FactoryGirl.define do
  factory :user do
    name "John Doe"
    sequence :email do |n|
      "email#{n}@multunus.org"
    end
    organization
  end
end