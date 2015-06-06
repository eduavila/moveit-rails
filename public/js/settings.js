var settings = {
  test:{
    apiUrl: "http://staging-move1t.herokuapp.com/"
  },
  production:{
    apiUrl: "http://192.168.2.240:3000/"
  },

  getSetting: function(setting){
    var settings = JSON.parse(localStorage.getItem("settings")) || {};
    var mode = settings.mode || "production";
    return this[mode][setting];
  }
};
