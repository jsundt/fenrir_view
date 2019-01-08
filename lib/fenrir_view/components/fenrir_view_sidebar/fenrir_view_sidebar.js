//----------------------------------------\\
// components: sidebar
//----------------------------------------\\

$(document).on('ready ajaxComplete', function() {

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

$(document).on('ready', function() {
  if ( localStorage.getItem('fenrir-sidebar-position') ) {
    $(".js-fenrir-view-sidebar").scrollTop( localStorage.getItem('fenrir-sidebar-position') );
  }

  $(".js-fenrir-view-sidebar").on('scroll', function() {
    localStorage.setItem('fenrir-sidebar-position', $(this).scrollTop());
  });
});
