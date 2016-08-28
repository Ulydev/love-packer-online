Uploads = new Mongo.Collection('uploads');

Router.configure({
    notFoundTemplate: "404",
    layoutTemplate: "pageLayout"
})

Router.route('/', function () {
  this.render('home');
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

Router.route("game/:_id", {

  subscriptions: function() {
    return Meteor.subscribe('game', this.params._id);
  },

  action: function () {
    if (this.ready()) {
      this.render("game", {
        data: function () {
          return Uploads.findOne({ id: this.params._id });
        }
      })
    } else {
      this.render("loading", {
        data: function () {
          return {
            title: this.params._id
          }
        }
      });
    }
  },

  name: 'game.show'

});
