


$(document).on('ready', function() {
  console.log('ready');

  $('.js-modal-cancel').on('click', function() {
    console.log("modal cancel action triggered");
    $(this).closest('.js-modal').hide();
  });
});