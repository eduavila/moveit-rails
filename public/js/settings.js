var settings = {
  test:{
    apiUrl: "http://staging-move1t.herokuapp.com/"
  },
  production:{
    apiUrl: "http://move1t.herokuapp.com/"
  },

  getSetting: function(setting){
    var settings = JSON.parse(localStorage.getItem("settings")) || {};
    var mode = settings.mode || "production";
    return this[mode][setting];
  }
};
