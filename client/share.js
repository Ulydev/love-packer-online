import { Template } from 'meteor/templating';

Template.pageLayout.helpers({
  link: function (title) {
    return "http://love.ulydev.com/game/" + title;
  }
});
