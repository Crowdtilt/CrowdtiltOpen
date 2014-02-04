var unsavedChangesChecker = function() {
    var warn;
    $('form').find(':input').each(function( i, el ) {
        if (el.type === 'checkbox') {
          if (el.checked != el.defaultChecked) {
              warn = true;
          }
        } else {
          if (el.value != el.defaultValue) {
              warn = true;
          }
        }
    });
    if (warn) {
        return "Your campaign changes have not been saved.";
    }
}

$(function() {
  var elements = '#admin_homepage_form, #admin_site_settings_form, #admin_campaign_form, #admin_customize_form';
  if ($(elements).length) {
    $(window).bind('beforeunload', unsavedChangesChecker);
  }
});
