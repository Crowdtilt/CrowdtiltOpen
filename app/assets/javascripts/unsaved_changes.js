var unsavedChangesChecker = function() {
    var warn;
    $('form').find(':input').each(function( i, el ) {
        if (el.value != el.defaultValue) {
            warn = true;
        }
    });
    if (warn) {
        return "Your campaign changes have not been saved.";
    }
}

$(function() {
  if ($('#admin_website_form, #admin_campaign_form').length) {
    $(window).bind('beforeunload', unsavedChangesChecker);
  }
});
