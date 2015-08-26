namespace :users_data do
  desc "Introducing organization for existing users"
  task update_organization: :environment do
  	org = Organization.find_by_name(Organization::MULTUNUS)
  	if org.blank?
  		org = Organization.create(name: Organization::MULTUNUS)
  		puts "Creating multunus organization"
  	end
  	User.all.each do |user|
  		if(user.email =~ /\A[\w+\-.]+@multunus.com/i) 
  			user.update_attributes(organization_id: org.id)
  			puts "Updated #{user.email} account to Multunus org"
  		end
  	end
  end
end