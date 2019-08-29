// @ts-check
// ----------------------------------------\\
// System component: navbar
// ----------------------------------------\\

if (!designSystem) {
  // @ts-ignore eslint-disable-next-line vars-on-top
  var designSystem = {};
}

if (!designSystem.system) {
  designSystem.system = {};
}

designSystem.system.navbar = {
  initialize: function($navbar) {
    if ( !$(this).data('initialized') ) {
      var instance = {
        $navbar: $navbar,
        $sidebar: $('.js-fenrir-view-sidebar'),
        $filter: $('.js-fenrir-view-navbar-filter-sidebar'),
      };

      instance.$filter.on('change keyup', function() {
        var filterValue = $(this).val().toLowerCase();

        instance.$sidebar.data('instance').filterItems(filterValue);
      });

      instance.$navbar.data('instance', instance);
      instance.$navbar.data('initialized', true);
    }
  },
  findNewInstances: function() {
    $('.js-fenrir-view-navbar').each(function() {
      designSystem.system.navbar.initialize($(this));
    });
  },
};

$(function() {
  designSystem.system.navbar.findNewInstances();

  $(document).on('ajaxComplete', function() {
    designSystem.system.navbar.findNewInstances();
  });
});
