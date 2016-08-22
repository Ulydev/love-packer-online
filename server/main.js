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
