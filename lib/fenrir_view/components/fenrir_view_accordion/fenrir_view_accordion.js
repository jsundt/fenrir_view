// @ts-check
// ----------------------------------------\\
// System component: accordion
// ----------------------------------------\\

if (!designSystem) {
  // @ts-ignore eslint-disable-next-line vars-on-top
  var designSystem = {};
}

if (!designSystem.system) {
  designSystem.system = {};
}

designSystem.system.accordion = {
  initialize: function($accordion) {
    if ( !$accordion.data('initialized') ) {
      var instance = {
        $accordion: $accordion,
        $accordionBar: $accordion.children('.js-fenrir-view-accordion-bar'),
        canOpen: $accordion.data('openable'),
        isOpen: function() {
          return this.$accordion.hasClass('is-open');
        },
        open: function() {
          this.$accordion.addClass('is-open');
          this.$accordion.children('.js-fenrir-view-accordion-content').slideDown(100);
        },
        close: function() {
          this.$accordion.removeClass('is-open');
          this.$accordion.children('.js-fenrir-view-accordion-content').slideUp(100);
        },
      };

      if (instance.canOpen) {
        if (instance.$accordion.attr('data-pre-open')) {
          instance.open();
        }

        instance.$accordionBar.on('click', function() {
          if (instance.isOpen()) {
            instance.close();
          } else {
            instance.open();
          }
        });
      }

      instance.$accordion.data('instance', instance);
      instance.$accordion.data('initialized', true);
    }

    return instance.$accordion;
  },
  findNewInstances: function() {
    $('.js-fenrir-view-accordion').each(function() {
      designSystem.system.accordion.initialize($(this));
    });
  },
};

$(function() {
  designSystem.system.accordion.findNewInstances();

  $(document).on('ajaxComplete', function() {
    designSystem.system.accordion.findNewInstances();
  });
});
