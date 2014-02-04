
$( document ).ready(function() {

  // validate '/admin/site-settings'
  $("#admin_site_settings_form").validate({
    //  by default, validate ignores any currently hidden fields, which is a problem since we allow users to hide fields.
    ignore: [],

    submitHandler: function (form) {
      $(window).unbind('beforeunload', unsavedChangesChecker);
      form.submit();
    },

    // validate the previously selected element when the user clicks out
    onfocusout: function(element) {
      $(element).valid();
    },

    // hide the loader when form is not valid and make sure individual errored fields are displayed
    invalidHandler: function(event, validator) {
      $(".loader").hide();
      validator.errorList.forEach(function(item, index, array) {
        $(item.element).closest('div.foldable').show();
      });
    },

    // validation rules
    rules: {
      "settings[site_name]": { required: true },
      "settings[reply_to_email]": { required: true, email: true },
      "settings[phone_number]": { phoneUS: true },
      "settings[header_link_url]": { url: true },
      "settings[tweet_text]": { maxlength: 120 },
      "settings[facebook_app_id]": { digits: true }
    },
    // validation messages
    messages: {
      "settings[site_name]": "Please enter your site name",
      "settings[reply_to_email]": {
        required: "Please enter a reply to email address",
        email: "Hmm. That doesn't look like a valid email"
      },
      "settings[phone_number]": {
        phoneUS: "Hmm. That doesn't look like a valid phone number. <br> ex: 555-555-5555"
      },
      "settings[header_link_url]": {
        url: "Hmm. That doesn't look like a valid URL. ex: http://crowdtilt.com"
      },
      "settings[tweet_text]": {
        maxlength: "Oops! Must be under 120 characters so we have room to include the link to your campaign"
      },
      "settings[facebook_app_id]": {
        digits: "Your Facebook app ID should only consist of numbers"
      }
    }

  });

  // validate customizations
  $("#admin_homepage_form").validate({

    // custom handler to call named function ""
    submitHandler: function (form) {
      $(window).unbind('beforeunload', unsavedChangesChecker);
      form.submit();
    }

  });

  // validate customizations
  $("#admin_customize_form").validate({

    // custom handler to call named function ""
    submitHandler: function (form) {
      var occ_msg_css = Crowdhoster.admin.checkSafety('settings_custom_css');
      var occ_msg_js = Crowdhoster.admin.checkSafety('settings_custom_js');
      if ( ( occ_msg_css != '' || occ_msg_js != '' ) && !Crowdhoster.admin.isSecurityCheckWarningDisplayed ){
        Crowdhoster.admin.checkSafetyAlert(occ_msg_css, 'settings_custom_css', 'settings_custom_css_alert');
        Crowdhoster.admin.checkSafetyAlert(occ_msg_js, 'settings_custom_js', 'settings_custom_js_alert');
        $('#settings_custom_alert').html('Please see the security warnings above with your custom CSS/JS. To continue anyway, click the save button again.');
        $('#settings_custom_alert').show();
        $(".loader").hide();
        Crowdhoster.admin.isSecurityCheckWarningDisplayed = true;
      } else {
        $(window).unbind('beforeunload', unsavedChangesChecker);
        Crowdhoster.admin.submitWebsiteForm(form);
      }
    }

  });

  // validate '/admin/campaigns/_form'
  $("#admin_campaign_form").validate({
    //  by default, validate ignores any currently hidden fields, which is a problem since we allow users to hide fields.
    ignore: [],

    // custom handler to call named function ""
    submitHandler: function (form) {
      $(window).unbind('beforeunload', unsavedChangesChecker);
      Crowdhoster.admin.submitCampaignForm(form);
    },

    // validate the previously selected element when the user clicks out
    onfocusout: function(element) {
      $element = $(element);
      if($element.attr('id') != 'campaign_expiration_date' || $element.hasClass('error')) {
        $element.valid();
      }
    },

    // hide the loader when form is not valid and make sure individual errored fields are displayed
    invalidHandler: function(event, validator) {
      $(".loader").hide();
      validator.errorList.forEach(function(item, index, array) {
        $(item.element).closest('div.foldable').show();
      });
    },

    // validation rules
    rules: {
      "campaign[name]": { required: true },
      "campaign[goal_dollars]": { required: true, number: true, min: 1 },
      "campaign[goal_orders]": { required: true, digits: true, min: 1 },
      "campaign[expiration_date]": { required: true, date: true },
      "campaign[min_payment_amount]": { required: true, number: true, min: 1 },
      "campaign[fixed_payment_amount]": { required: true, number: true, min: 1 },
      "campaign[additional_info_label]": { required: {depends: function(element) {
        return $('#campaign_collect_additional_info:checked').length > 0;
      }}},
      "campaign[reward_reference]": { required: true },
      "reward[][price]": { required: true, number: true },
      "reward[][title]": { required: true },
      "reward[][image_url]": { url: true },
      "reward[][description]": { required: true },
      "reward[][delivery_date]": { required: true },
      "reward[][number]": { number: true },
      "campaign[contributor_reference]": { required: true },
      "campaign[video_embed_id]": { minlength: 11 , maxlength: 11},
      "campaign[primary_call_to_action_button]": { required: true },
      "campaign[secondary_call_to_action_button]": { required: true },
      "campaign[comments_shortname]": { required: { depends: function(element) {
        return $('#campaign_include_comments:checked').length > 0;
      }}},
      "campaign[tweet_text]": { maxlength: 120 }
    },
    // validation messages
    messages: {
      "campaign[name]": {
        required: "You must pick a name for your campaign"
      },
      "campaign[goal_dollars]": {
        required: "You must specify a goal dollar amount",
        number: "Numbers only, please",
        min: "Please enter a goal of $1 or greater"
      },
      "campaign[goal_orders]": {
        required: "You must specify a goal",
        digits: "Numbers only, please, no decimals",
        min: "Please enter a goal of 1 or greater"
      },
      "campaign[expiration_date]": {
        required: "You must select a date from the calendar",
        date: "Strange... that doesn't look like a valid date and time"
      },
      "campaign[min_payment_amount]": {
        required: "You must specify a minimum payment amount",
        number: "Numbers only, please",
        min: "Please enter a minimum payment amount higher than $1"
      },
      "campaign[fixed_payment_amount]": {
        required: "You must specify a fixed payment amount",
        number: "Numbers only, please",
        min: "Please enter a fixed payment amount higher than $1"
      },
      "campaign[additional_info_label]": {
        required: "Please describe what additional info you need"
      },
      "campaign[reward_reference]": {
        required: "You must choose a word"
      },
      "reward[][price]": {
        required: "You must enter a price",
        number: "The price must be a number"
      },
      "reward[][title]": {
        required: "You must enter a title"
      },
      "reward[][image_url]": {
        url: "This must be a valid image URL"
      },
      "reward[][description]": {
        required: "You must enter a description"
      },
      "reward[][delivery_date]": {
        required: "You must choose a delivery date"
      },
      "reward[][number]": {
        number: "This must be a number"
      },
      "campaign[contributor_reference]": {
        required: "You must choose a word"
      },
      "campaign[video_embed_id]": {
        minlength: "Your Youtube ID is too short! <br> It should be 11 characters long.",
        maxlength: "Oops. Don't include the whole link. <br> Only paste the last 11 characters of the URL."
      },
      "campaign[primary_call_to_action_button]": {
        required: "You need some text here -- can't raise funds without it!"
      },
      "campaign[secondary_call_to_action_button]": {
        required: "You need some text here -- can't raise funds without it!"
      },
      "campaign[comments_shortname]": {
        required: "You must provide your Disqus shortname to enable comments"
      },
      "campaign[tweet_text]": {
        maxlength: "Oops! Must be under 120 characters so we have room to include the link to your campaign."
      }
    }

  });

  // validate '/admin/bank-setup'
  $("#admin_bank_form").validate({

    // custom handler to call named function ""
    submitHandler: function (form) {
      Crowdhoster.admin.submitBankForm(form);
    },

    // validate the previously selected element when the user clicks out
    onfocusout: function(element) {
      $(element).valid();
    },

    // hide the loader when form is not valid
    // add back in name attributes when form is not valid
    invalidHandler: function(event, validator) {
      $(".loader").hide();
      $('#bank_routing_number').attr('name', 'bank_routing_number');
      $('#account_number').attr('name', 'account_number');
    },

    // validation rules
    rules: {
      full_legal_name: { required: true },
      phone: { required: true, phoneUS: true },
      street_address: { required: true },
      zip: { required: true },
      birth_year: { required: true, number: true, minlength: 4, maxlength: 4 },
      bank_routing_number: { required: true, number: true, minlength: 9, usRoutingNumber: true },
      account_number: { required: true }
    },
    // validation messages
    messages: {
      full_legal_name: {
        required: "We need your full, legal name"
      },
      phone: {
        required: "We need your phone number",
        phoneUS: "Oops! That doesn't look valid"
      },
      street_address: {
        required: "We need your street address"
      },
      zip: {
        required: "We need your zip code"
      },
      birth_year: {
        required: "We need to know when you were born.",
        number: "No letters in birth years!",
        minlength: "Too few digits! You're not that old, are you?!",
        maxlength: "Too many digits! Are you from the future?!"
      },
      bank_routing_number: {
        required: "We need this to deposit funds<br> in your account.",
        number: "No letters in the routing number!",
        minlength: "US routing numbers are 9 digits",
        usRoutingNumber: "Hmm. That routing number <br> doesn't look valid."
      },
      account_number: {
        required: "We need this to deposit funds<br> in your account."
      }
    }

  });

  // validate '{campaign_name}/checkout/payment'
  $("#payment_form").validate({

    // custom handler to call named function "do_payment"
    submitHandler: function(form) {
      Crowdhoster.campaigns.submitPaymentForm(form);
    },

    // validate the previously selected element when the user clicks out
    onfocusout: function(element) {
      $(element).valid();
    },

    // hide the loader when form is not valid
    // add back in name attributes when form is not valid
    invalidHandler: function(event, validator) {
      $(".loader").hide();
      $('#card_number').attr('name', 'card_number');
      $('#security_code').attr('name', 'security_code');
    },

    // validation rules
    rules: {
      fullname: { required: true },
      email: { required: true, email: true },
      address_one: { required: true },
      city: { required: true },
      state: { required: true },
      postal_code: { required: true },
      country: { required: true },
      card_number: { required: true, minlength: 12, creditcard: true},
      security_code: { required: true, number: true, minlength: 3, maxlength: 4 },
      billing_postal_code: { required: true, minlength: 3, maxlength: 10 }
    },
    // validation messages
    messages: {
      fullname: {
        required: "We need your full name to process your payment."
      },
      email: {
        required: "Please enter your email address.",
        email: "Hmm. That doesn't look like a valid email."
      },
      address_one: {
        required: "We need your street address"
      },
      city: {
        required: "We need your city"
      },
      state: {
        required: "We need your state"
      },
      postal_code: {
        required: "We need your postal code"
      },
      country: {
        required: "Please select a country"
      },
      card_number: {
        required: "We need your card number to charge it",
        minlength: "Hmm. That doesn't look valid just yet.",
        creditcard: "Hmm. That doesn't look valid just yet."
      },
      security_code: {
        required: "Your security code is required. Fill 'er in!",
        number: "Numbers only for the security code!",
        minlength: "Security codes are at least 3 digits!",
        maxlength: "Security codes are 4 digits or less!"
      },
      billing_postal_code: {
        required: "We need your billing postal code",
        minlength: "That doesn't look like a valid postal code",
        maxlength: "That doesn't look like a valid postal code"
      }
    }

  });

});
