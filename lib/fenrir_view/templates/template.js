// ----------------------------------------\\
// <%= component_name %>
// ----------------------------------------\\

if (!designSystem) {
  // eslint-disable-next-line vars-on-top
  var designSystem = {};
}

designSystem.<%= js_variable_name %> = {
  initialize: function($<%= js_variable_name %>) {

    // Avoid initializing methods on the same DOM element multiple times
    if ( !$<%= js_variable_name %>.data('initialized') ) {
      var instance = {
        $<%= js_variable_name %>: $<%= js_variable_name %>,
        doThing: function() {
          this.$<%= js_variable_name %>.addClass('thing-has-been-done');
        },
      };

      // Save a reference to this instances javascript functions on the DOM element.
      // This is then accessible from $(<selector>).data('instance');
      // Eg. $(<selector>).data('instance').doThing();
      $<%= js_variable_name %>.data('instance', instance);
      $<%= js_variable_name %>.data('initialized', true);
    }
  }
};

$(document).on('ready ajaxComplete', function() {
  $('.<%= js_class_name %>').each(function() {
    designSystem.<%= js_variable_name %>.initialize($(this));
  });
});
