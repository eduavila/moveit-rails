FactoryGirl.define do
  factory :entry do
    date Date.today
    duration { 10 }
    user
  end
  factory :second_entry, class: Entry do
    date Date.today
    duration { 20 }
  end
end
