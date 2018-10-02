//----------------------------------------\\
// components: sidebar
//----------------------------------------\\

$(document).on('ready ajaxComplete', function() {

  // $('.js-fenrir-view-sidebar').each(function() {
  //   if ( !$(this).data('initialized') ) {
  //     $(this).data('initialized', true);
  //   }
  // });

  $('.js-fenrir-view-navbar__sidebar-toggle').each(function() {
    if ( !$(this).data('initialized') ) {
      var $this = $(this);

      $this.on('click', function() {
        $('.js-fenrir-view-sidebar').toggleClass('is-showing');
      });

      $this.data('initialized', true);
    }
  });

});
