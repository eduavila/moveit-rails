namespace :initialize_users do
  desc "TODO"
  task from_slack_user_data: :environment do
  	slacks_users = '[{"name":"Akshay","slack_user_name":"@akshay","email":"akshay.s@multunus.com"},{"name":"Anitha","slack_user_name":"@anitha.s","email":"anitha.s@multunus.com"},{"name":"Arun","slack_user_name":"@arun","email":"arun.p@multunus.com"},{"name":"Ashwini","slack_user_name":"@minchu","email":"ashwini.m@multunus.com"},{"name":"Chala","slack_user_name":"@chala","email":"chalapathi.k@multunus.com"},{"name":"Ernest","slack_user_name":"@ernest","email":"ernest.s@multunus.com"},{"name":"Frank","slack_user_name":"@frank","email":"franklin.p@multunus.com"},{"name":"Janaki","slack_user_name":"@janaki","email":"janaki.g@multunus.com"},{"name":"Jerry","slack_user_name":"@jerry","email":"jerry.j@multunus.comjerry.john.jacob@live.com"},{"name":"Karthik","slack_user_name":"@gupta","email":"karthik.g@multunus.com"},{"name":"Krishnaprasad","slack_user_name":"@krishnaprasad","email":"krishnaprasad.r@multunus.com"},{"name":"Kuldip","slack_user_name":"@kuldip.c","email":"kuldip.c@multunus.com"},{"name":"Leena","slack_user_name":"@leena","email":"leena.sn@multunus.com"},{"name":"Madhuri","slack_user_name":"@madhuri","email":"madhuri.n@multunus.com"},{"name":"Manish","slack_user_name":"@manish","email":"manish.c@multunus.com"},{"name":"Manoj","slack_user_name":"@manoj","email":"manojkumar.n@multunus.com"},{"name":"Midhun","slack_user_name":"@midhun","email":"midhun.k@multunus.com"},{"name":"Muraleekrishna","slack_user_name":"@muraleekrishna","email":"muraleekrishna.g@multunus.com"},{"name":"ramya","slack_user_name":"@ramya","email":"ramyasree.d@multunus.com"},{"name":"Sreenath","slack_user_name":"@sreenath","email":"sreenath.n@multunus.com"},{"name":"Vaidy","slack_user_name":"@vaidy","email":"vaidyanathan.b@multunus.com"},{"name":"Vaish","slack_user_name":"@vaish","email":"vaishnavi.k@multunus.com"},{"name":"Vimal","slack_user_name":"@vimalvnair","email":"vimal.v@multunus.com"},{"name":"Yedhu","slack_user_name":"@yedhukrishnan","email":"yedhu.k@multunus.com"}]'
  	slack_users_json= JSON.parse(slacks_users)

  	slack_users_json.each do |user_json|
  	  user = User.find_by_email(user_json["email"])
  	  if user
  	  	user.update_attributes(slack_user_name: user_json["slack_user_name"])
  	  	puts "Updated user: #{user.name} with slack_user_name: #{user.slack_user_name}"
  	  else
  	  	new_user = User.create(email: user_json["email"],name: user_json["name"], slack_user_name: user_json["slack_user_name"])
  	  	puts "Created user: #{new_user.name} with slack_user_name: #{new_user.slack_user_name}"
  	  end
  	end
  end

end