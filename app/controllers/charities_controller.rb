class CharitiesController < ApiController
  def index 
  	render json: {
  		charity_monthly_breakdown: [
  			{
  				month: "June 2015",
  				total_contribution: 30738,
  				charities: [
  					{
  						name: "Charity water",
  						URL: "http://www.charitywater.org/",
  						amount: 30738,
  						description: "We provided 16 people with clear drinking water."
  					}
  				]
  			},
  			{
  				month: "May 2015",
  				total_contribution: 33656,
  				charities: [
  					{
  						name: "Charity water",
  						URL: "http://www.charitywater.org/",
  						amount: 18656,
  						description: "We provided 10 people with clear drinking water."
  					},
  					{
  						name: "Join the Dots",
  						URL: "http://jtdfoundation.org/",
  						amount: 15000,
  						description: "In the area of rural education, 'Join the dots' foundation prevents students from discontinuing their education due to socio-economic factors."
  					}
  				]
  			},
  			{
  				month: "April 2015",
  				total_contribution: 31138,
  				charities: [
  					{
  						name: "Charity water",
  						URL: "http://www.charitywater.org/",
  						amount: 31138,
  						description: "An initiative to help people effected by Nepal earthquake through Charity:Water"
  					}
  				]
  			},
  			{
  				month: "March 2015",
  				total_contribution: 13750,
  				charities: [
  					{
  						name: "Give India : Education",
  						URL: "http://www.giveindia.org/p-2789-reimburse-one-semester-education-expenses-of-a-bright-and-financially-needy-engineering-student.aspx",
  						amount: 13750,
  						description: "Reimburse a part of education expenses for Basavaraj, a bright and financially needy NIT Surathkal engineering student through NGO - FFE India Trust."
  					}
  				]
  			}
  		]
  	}
  end
end
