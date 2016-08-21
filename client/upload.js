import { Template } from 'meteor/templating';

Session.set('readyId', null);

Template.uploadForm.helpers({
  uploadCallbacks: function () {
    return {
      finished: function (index, fileInfo, context) {
        Router.go('game.share', { _id: fileInfo.id });
      }
    };
  }
});
