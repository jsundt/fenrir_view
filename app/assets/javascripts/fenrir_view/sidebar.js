


// Persist sidebar position between page loads

$(document).on('ready', function() {
  if ( localStorage.getItem('fenrir-sidebar-position') ) {
    $("#styleguide-nav").scrollTop( localStorage.getItem('fenrir-sidebar-position') );
  }

  $("#styleguide-nav").on('scroll', function() {
    localStorage.setItem('fenrir-sidebar-position', $(this).scrollTop());
  });
});
