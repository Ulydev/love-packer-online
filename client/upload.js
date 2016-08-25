import { Template } from 'meteor/templating';

Session.set('readyId', null);

Template.uploadForm.helpers({
  uploadCallbacks: function () {
    return {
      validate: function(files) {
        var file = files[0];
        if (file.name.slice(-5) != '.love') {
          Notifications.error("Error", "Not a .love file");
          return false;
        }
        if ((!file) || (file.name && file.name.length < 3 + 5) || (!file.name)) {
          Notifications.error("Error", "Game name must be more than 3 characters long");
          return false;
        }
        return true;
      },
      finished: function (index, fileInfo, context) {
        Notifications.success("Success", "Uploaded " + fileInfo.id, {});
        Router.go('game.share', { _id: fileInfo.id });
      },
      formData: function () {
        return { private: document.getElementById("isprivate").checked }
      }
    };
  }
});
