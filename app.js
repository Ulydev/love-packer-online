Uploads = new Mongo.Collection('uploads');

Router.configure({
    notFoundTemplate: "404",
    layoutTemplate: "pageLayout"
})

Router.route('/', function () {
  this.render('uploadForm');
});

Router.route("share/:_id", function () {
  this.render('sharePage', {
    data: function () {
      return {
        title: this.params._id
      }
    }
  });
}, {
  name: 'game.share'
});

Router.route("game/:_id", function () {
  var game = Uploads.findOne({ id: this.params._id });
  if (!game) {
    this.render("404", {
      data: function () {
        return {
          title: this.params._id
        }
      }
    });
  } else {
    this.render("game", {
      data: function () {
        return Uploads.findOne({ id: this.params._id });
      }
    });
  }
}, {
  name: 'game.show'
});
