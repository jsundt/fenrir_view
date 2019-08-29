// @ts-check
//----------------------------------------\\
// System component: sidebar
//----------------------------------------\\

if (!designSystem) {
  // @ts-ignore eslint-disable-next-line vars-on-top
  var designSystem = {};
}

if (!designSystem.system) {
  designSystem.system = {};
}

designSystem.system.sidebar = {
  initialize: function($sidebar) {
    if ( !$(this).data('initialized') ) {
      var instance = {
        $sidebar: $sidebar,
        $items: $sidebar.find('.js-fenrir-view-sidebar__item'),
        storageKey: 'fenrir-sidebar-position',
        toggle: function() {
          this.$sidebar.toggleClass('is-showing');
        },
        setLocation: function() {
          localStorage.setItem(this.storageKey, this.$sidebar.scrollTop());
        },
        getLocation: function() {
          if ( localStorage.getItem(this.storageKey) ) {
            this.$sidebar.scrollTop( localStorage.getItem(this.storageKey) );
          }
        },
        resetFilter: function() {
          this.$items.show();
          this.$sidebar.addClass('is-showing');
          $('.js-fenrir-view-sidebar__category').removeClass('is-filtered');
          $('.js-fenrir-view-sidebar__filter-error').hide();
        },
        findItems: function(filterValue) {
          return $.map(this.$items, function(element) {
            var value = $(element).data('fenrir-view-filter-types').toLowerCase();
            return value.indexOf(filterValue) === -1  ? element : null;
          });
        },
        filterItems: function(filterValue) {
          this.resetFilter();

          if (filterValue.length) {
            var itemsToHide = this.findItems(filterValue);
            $(itemsToHide).hide();

            $('.js-fenrir-view-sidebar__category-pages').each(function() {
              var $items = $(this).find('.js-fenrir-view-sidebar__item');
              var visibleItems = $.map($items, function(element) {
                if ($(element)[0].style.display !== 'none') {
                  return true;
                }
              });

              if (visibleItems.length === 0) {
                $(this).closest('.js-fenrir-view-sidebar__category').addClass('is-filtered');
              }
            });
  
            if (!$('.js-fenrir-view-sidebar__category:not(.is-filtered)').length) {
              $('.js-fenrir-view-sidebar__filter-error').show();
            }
          }
        },
      };

      instance.getLocation();

      instance.$sidebar.on('scroll', function() {
        instance.setLocation();
      });

      $('.js-fenrir-view-navbar__sidebar-toggle').each(function() {
        $(this).on('click', function() {
          instance.toggle();
        });
      });

      instance.$sidebar.data('instance', instance);
      instance.$sidebar.data('initialized', true);
    }
  },
  findNewInstances: function() {
    $('.js-fenrir-view-sidebar').each(function() {
      designSystem.system.sidebar.initialize($(this));
    });
  },
};

$(function() {
  designSystem.system.sidebar.findNewInstances();

  $(document).on('ajaxComplete', function() {
    designSystem.system.sidebar.findNewInstances();
  });
});
