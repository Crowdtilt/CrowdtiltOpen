$( document ).ready(function() {

  $(function() {
    if ($('#campaign').length > 0) {
      _gaq.push ["_trackEvent", "campaigns", "viewed", "campaign page"];
    }
  });

  $("#main_cta").click(function() {
    _gaq.push ["_trackEvent", "campaigns", "clicked", "main CTA button"];
  });

  $("#secondary_cta").click(function() {
    _gaq.push ["_trackEvent", "campaigns", "clicked", "secondary CTA button"];
  });

  $("#rewards_click").click(function() {
    _gaq.push ["_trackEvent", "campaigns", "clicked", "reward"];
  });

  $("#continue_to_checkout").click(function() {
    _gaq.push ["_trackEvent", "campaigns", "clicked", "continue to checkout"];
  });

  $(function() {
    if ($('#completed_purchase').length > 0) {
      _gaq.push ["_trackEvent", "campaigns", "completed purchase", "checkout confirmation page"];
    }
  });

});
