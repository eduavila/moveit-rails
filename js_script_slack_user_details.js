/* 
URL: https://(subdomain).slack.com/team 
Active Tab: Full Members list
*/


var slack_user_details = [];
$(".tab_pane.selected.active .member_item").each(function(){
	var user_name = $.trim($(this).find(".member_name").first().text());	
	var slack_user_name = $.trim($(this).find(".member_name_and_title").first().find(":nth-child(2)").text());
	var slack_email = $.trim($(this).find(".member_data_table").first().find("a:contains('@')").text());

	slack_user_details.push({'name': user_name.split(" ")[0], 'slack_user_name' : slack_user_name, 'email' : slack_email});
});
slack_user_details.pop(); //remove @slacbot
JSON.stringify(slack_user_details);


