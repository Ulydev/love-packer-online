$.Velocity.RegisterEffect('transition.fadeInRight', {
  defaultDuration: 500,
  calls: [
    [{translateX: ['0%', '100%'], translateZ: 0, easing: "ease-in", opacity: [1, 0]}]
  ]
});

$.Velocity.RegisterEffect('transition.fadeOutLeft', {
  defaultDuration: 500,
  calls: [
    [{translateX: ['-100%', '0%'], translateZ: 0, easing: "ease-out", opacity: [0, 1]}]
  ]
});

Transitioner.default({
  in: 'transition.fadeInRight',
  out: 'transition.fadeOutLeft'
});

Notifications.defaultOptions.timeout = 4000;
