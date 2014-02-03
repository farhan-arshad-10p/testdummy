App.ClipperController = Ember.Controller.extend
  clipper: "javascript:(function()%7Bif(window.myBookmarklet!%3D%3Dundefined)%7BmyBookmarklet()%3B%7Delse%7Bdocument.body.appendChild(document.createElement(%27script%27)).src%3D%27#{location.origin}/assets/clipper.js?rand='+Math.random()+'%3F%27%3B%7D%7D)()%3B"
