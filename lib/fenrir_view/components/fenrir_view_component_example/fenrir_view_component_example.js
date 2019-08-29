// @ts-check
//----------------------------------------\\
// System component: Component example
//----------------------------------------\\

if (!designSystem) {
  // @ts-ignore eslint-disable-next-line vars-on-top
  var designSystem = {};
}

if (!designSystem.system) {
  designSystem.system = {};
}

designSystem.system.componentExample = {
  initialize: function($componentExample) {
    if ( !$(this).data('initialized') ) {
      var instance = {
        $componentExample: $componentExample,
        $sourceCode: $componentExample.find('.js-fenrir-view-component-example__source'),
        $sourceCodeToggle: $componentExample.find('.js-fenrir-view-component-example__source-toggle'),
        toggleSource: function() {
          this.$sourceCode.toggleClass('is-open');
        }
      };

      instance.$sourceCodeToggle.on('click', function() {
        instance.toggleSource();

        if ($.trim($(this).text()) == 'View source') {
          $(this).text('Hide source');
        } else {
          $(this).text('View source');
        }
      });

      $componentExample.data('instance', instance);
      $componentExample.data('initialized', true);
    }
  },
  findNewInstances: function() {
    $('.js-fenrir-view-component-example').each(function() {
      designSystem.system.componentExample.initialize($(this));
    });
  },
};

$(function() {
  designSystem.system.componentExample.findNewInstances();

  $(document).on('ajaxComplete', function() {
    designSystem.system.componentExample.findNewInstances();
  });
});
