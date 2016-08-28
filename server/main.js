import { Meteor } from 'meteor/meteor';

SyncedCron.add({
  name: 'Remove old Entries (16 Days)',
  schedule: function(parser) {
  	return parser.text('every 8 hours');
  },
  job: function() {
  	var today = new Date();
  	var targetDate = new Date();

  	targetDate.setDate(today.getDate() - 16);
  	targetDate.setHours(0);
  	targetDate.setMinutes(0);
  	targetDate.setSeconds(0);

    var cursor = Uploads.find({lastUpdated: {$lt: targetDate}});
    cursor.forEach(function(doc){
      exec('rm -rf /.uploads/games/' + doc.id);
    });

  	// Remove matchng Documents
  	Uploads.remove({createdAt: {$lt: targetDate}});
  }
});

Meteor.methods({

  viewGame: function (id) {
    console.log("updating game " + id);
    Uploads.update({ id: id }, {
      $inc: {
        views: 1
      },
      $set: {
        lastUpdated: new Date()
      }
    });
  }

});

Meteor.publish('recent', function(limit) {
  return Uploads.find({ private: false }, {
    limit: limit || 5,
    sort: { createdAt: -1 }
  });
});

Meteor.publish('popular', function(limit) {
  return Uploads.find({ private: false }, {
    limit: limit || 5,
    sort: { views: -1 }
  });
});

Meteor.publish("game", function(id) {
  return Uploads.find({ id: id });
})
