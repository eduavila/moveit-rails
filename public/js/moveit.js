$(function(){
  $('.add-entry-btn').on('click', 'i' , function(){
    window.location = "index.html";
  });
});

var isRunningOnBrowser = function() {
  var app = document.URL.indexOf( 'http://' ) === -1 && document.URL.indexOf( 'https://' ) === -1;
  if ( app ) {
    console.log("App runnning in Native app");
    return false;
  } else {
    console.log("App runnning in Browser");
    return true;    
  }  
}

var saveUserDetailsForNativeServices = function(userDetails) {
  console.log("Save User details for Native IF native app: "+userDetails["email"]);
  if( isRunningOnBrowser() == false) {
    SharedPreferenceInterface.putString("email", userDetails["email"]);
  }
};

var disableSaveButtonWith = function(form, text){
  var saveBtn = $(form).find('button[type=submit]')[0];
  saveBtn.disabled = true;
  saveBtn.textContent = text;
};

var enableSaveButtonWith = function(form, text){
  var saveBtn = $(form).find('button[type=submit]')[0];
  saveBtn.disabled = false;
  saveBtn.textContent = text;
};

var getParameterByName = function(name, location) {
  var query_name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
  var regex = new RegExp("[\\?&]" + query_name + "=([^&#]*)"),
      results = regex.exec(location.search);
  return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
};

var setUnreadNotificationStatus = function() {
  $.ajax({
   dataType: 'json',
   url: settings.getSetting("apiUrl") + 'notifications/unread.json',
   type: "GET",
   data: {email: localStorage.getItem("userEmail")},
   success: function(data, textStatus, jqXHR){
    var unreadCount = data.length;
    $("a.notifications-link .notification-count").text(unreadCount);
    if(unreadCount > 0){
      $("a.notifications-link").addClass("active");
    }
   },
   error: function(){
    console.log("Failed to fetch UNREAD notifications");
  },
  timeout: 30000
 }); 
}

var UserInteraction = {
  action: function(fromEmail, toEmail, draggable, action, name){

    if(fromEmail != toEmail &&  action != 'none'){
      draggable.animate({
        left: '+=400px'
      }, 250);

      draggable.siblings('.interaction-message.' + action + 'ing').removeClass('hidden');
      draggable.hide();

      var data = {
        from_email_id : fromEmail,
        to_email_id : toEmail,
        interaction_type: action
      };

      $.ajax({
        dataType: 'json',
        url: settings.getSetting("apiUrl") + "interaction.json",
        type: 'POST',
        data: data,
        success: function(data, textStatus, jqXHR) {
          console.log(action + "ing....");
          Materialize.toast("You " + action + "'d " + name, 2000);
          draggable.unbind("swiperight");
          draggable.find('.action').removeClass(action).addClass('none');
        },
        error: function() {
          Materialize.toast("Please check your internet connection.", 3000);
        }
      });

      setTimeout(function(){
        draggable.show();
        draggable.animate({
          left: '-=400px'
        }, 250);
        draggable.siblings('.interaction-message.' + action + 'ing').addClass('hidden');
      }, 500);
    }
  }
};

