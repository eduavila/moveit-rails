FactoryGirl.define do
	factory :entry do
		date Date.today
		duration { rand(10..100) }
	end
end
