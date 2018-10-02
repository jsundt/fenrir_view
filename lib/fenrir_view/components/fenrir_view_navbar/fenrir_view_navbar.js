// ----------------------------------------\\
// modules: navbar
// ----------------------------------------\\

function hideNavbarDropdown() {
  $('.js-fenrir-view-navbar__item').removeClass('is-open');
}

function openNavbarDropdown($item) {
  $item.addClass('is-open');
}

$(document).on('ready ajaxComplete', function() {
  $('.js-fenrir-view-navbar').each(function() {
    var $navbar = $(this);

    if ( !$navbar.data('initialized') ) {
      $navbar.find('.js-fenrir-view-navbar__dropdown-trigger').on('mousedown', function() {
        var $self = $(this);
        var $item = $self.closest('.js-fenrir-view-navbar__item');

        if ( $item.hasClass('is-open') ) {
          hideNavbarDropdown();
        } else {
          hideNavbarDropdown();
          openNavbarDropdown($item);
        }
      });

      $navbar.find('.js-fenrir-view-navbar__dropdown-trigger').on('mouseenter focusin', function() {
        var $self = $(this);
        var $item = $self.closest('.js-fenrir-view-navbar__item');

        hideNavbarDropdown();
        openNavbarDropdown($item);
      });

      $navbar.find('.js-fenrir-view-navbar__dropdown-trigger').on('mouseleave focusout', function(e) {
        var dropdown = $(this).closest('.js-fenrir-view-navbar__item');

        if (!dropdown.is(e.relatedTarget) && dropdown.has(e.relatedTarget).length === 0) {
          hideNavbarDropdown();
        }
      });

      $navbar.find('.js-fenrir-view-navbar__dropdown').on('mouseleave', function() {
        hideNavbarDropdown();
      });

      $navbar.find('.js-fenrir-view-navbar__dropdown').each(function() {
        var $items = $(this).find('.js-fenrir-view-navbar__link');
        var $lastItem = $items.last();

        $lastItem.on('focusout', function() {
          hideNavbarDropdown();
        });
      });

      $navbar.data('initialized', true);
    }
  });
});

$(document).on('mouseup', function(e) {
  var dropdowns = $('.js-fenrir-view-navbar__dropdown-trigger').closest('.js-fenrir-view-navbar__item');

  // When you click, and there are dropdowns
  // hide them if you click outside of them
  if (dropdowns && !dropdowns.is(e.target) && dropdowns.has(e.target).length === 0) {
    hideNavbarDropdown();
  }
});
