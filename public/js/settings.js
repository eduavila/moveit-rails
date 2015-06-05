var settings = {
  test:{
    baseUrl: "http://staging-move1t.herokuapp.com/",
    apiUrl: "http://staging-move1t.herokuapp.com/"
  },
  production:{
    baseUrl: "http://staging-move1t.herokuapp.com/",
    apiUrl: "http://staging-move1t.herokuapp.com/"
  },

  getSetting: function(setting){
    var settings = JSON.parse(localStorage.getItem("settings")) || {};
    var mode = settings.mode || "production";
    return this[mode][setting];
  }
};
