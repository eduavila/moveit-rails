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
  						description: "Helping almost 16 people getting drinking water"
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
  						description: "Helping people in need. 10 people got drinking water because of this."
  					},
  					{
  						name: "Join the Dots",
  						URL: "http://www.joiningthedots.org/",
  						amount: 15000,
  						description: "Lending our hand of help to Nepal earthquake casualties"
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
  						description: "Helping almost 16 people getting drinking water"
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
  						description: "Reimburse education expenses of a bright and financially needy engineering student "
  					}
  				]
  			}
  		]
  	}
  end
end
