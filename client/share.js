import { Template } from 'meteor/templating';

Template.shareButtons.helpers({
  link: function (title) {
    return "http://love.ulydev.com/game/" + title;
  }
});
