import { Template } from 'meteor/templating';

Template.showcase.helpers({
  recent: function () {
    return Uploads.find({}, {
      limit: 6,
      sort: { createdAt: -1 }
    });
  },
  popular: function () {
    return Uploads.find({}, {
      limit: 6,
      sort: { views: -1 }
    });
  },
  slice: function (id) {
    return id.slice(-5);
  }
});
