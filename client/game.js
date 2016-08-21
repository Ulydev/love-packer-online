import { Template } from 'meteor/templating';

Template.game.helpers({
  gameCanvasUrl: function () {
    return "/canvas.js";
  },
  gameUrl: function () {
    return this.baseUrl + this.id + "/game.js";
  },
  loveUrl: function () {
    return "/love.js";
  }
});
