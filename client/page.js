import { Template } from 'meteor/templating';

Template.pageLayout.helpers({
  isLoading: function () {
    return Session.get('isLoading');
  }
});
