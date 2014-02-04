Crowdhoster.admin =

  init: ->
    isSecurityCheckWarningDisplayed = false
    _this = this

    #
    # All admin pages
    #

    # Customization Form
    $('#settings_custom_css').on "change", (e) ->
      occ_msg = Crowdhoster.admin.checkSafety('settings_custom_css')
      Crowdhoster.admin.checkSafetyAlert(occ_msg, 'settings_custom_css', 'settings_custom_css_alert')

    $('#settings_custom_js').on "change", (e) ->
      occ_msg = Crowdhoster.admin.checkSafety('settings_custom_js')
      Crowdhoster.admin.checkSafetyAlert(occ_msg, 'settings_custom_js', 'settings_custom_js_alert')

    #  Campaign Form

    $('legend.foldable').on 'click', (e) ->
      $(this).parent().find('div.foldable').slideToggle()

    # hide foldable divs, but only when javascript is enabled
    $('div.foldable').not('.default_expanded').hide()

    $('#campaign_expiration_date').datetimepicker({
      timeFormat: "h:mm tt",
      minDate: new Date()
    });

    d = $('#campaign_expiration_date').val()
    if(d && d.length > 0)
      d = new Date(d)
      h = d.getHours()
      if(h > 12)
        t = (h-12) + ':' + ("0" + d.getMinutes()).slice(-2) + ' pm'
      else
        if(h == 0)
          h = 12
        t = h + ':' + ("0" + d.getMinutes()).slice(-2) + ' am'
      $('#campaign_expiration_date').val($.datepicker.formatDate('mm/dd/yy',d) + ' ' + t)

    if $('#campaign_expiration_date').length
      $('#campaign_expiration_date')[0].defaultValue = $('#campaign_expiration_date').val()

    $('input#campaign_collect_additional_info').on "change", ->
      $('.additional_info_input').slideToggle()

    $('input#campaign_include_comments').on "change", ->
      $('.include_comments_input').slideToggle()

    $('input[name="campaign[media_type]"]').on "change", ->
      $('#video-options').slideToggle()
      $('#image-options').slideToggle()

    $('input#campaign_payment_type_any').on "change", ->
      $('#preset-amount').slideUp()
      $('#min-amount').slideUp()
      $('#no-rewards').slideUp()
      $('#rewards').slideDown()
      $('#campaign_collect_shipping_message').hide()
      $('#campaign_collect_shipping_warning').show()
      $('#global-shipping-check').hide()

    $('input#campaign_payment_type_fixed').on "change", ->
      $('#min-amount').slideUp()
      $('#preset-amount').slideDown()
      $('#rewards').slideUp()
      $('#no-rewards').slideDown()
      $('#global-shipping').slideDown()
      $('#global-shipping-check').show()
      $('#campaign_collect_shipping_message').show()
      $('#campaign_collect_shipping_warning').hide()

    $('input#campaign_payment_type_min').on "change", ->
      $('#preset-amount').slideUp()
      $('#min-amount').slideDown()
      $('#no-rewards').slideUp()
      $('#rewards').slideDown()
      $('#campaign_collect_shipping_message').hide()
      $('#campaign_collect_shipping_warning').show()
      $('#global-shipping-check').hide()

    $('input#goal_type_dollars').on "change", ->
      $('input#campaign_payment_type_min').attr('disabled', false)
      $('input#campaign_payment_type_any').attr('disabled', false)
      $('#flexible_payment_options').show()
      $('.amount_input').slideDown()
      $('.orders_input').slideUp()

    $('input#goal_type_orders').on "change", ->
      $('input#campaign_payment_type_fixed').trigger('click')
      $('input#campaign_payment_type_min').attr('disabled', true)
      $('input#campaign_payment_type_any').attr('disabled', true)
      $('#flexible_payment_options').hide()
      $('.amount_input').slideUp()
      $('.orders_input').slideDown()

    $('#reward-add').on 'click', (e) ->
      e.preventDefault()
      $('#rewards ul').append('<li><table class="table"><tr><th>Reward</th><th>Number Claimed</th><th>Delete?</th></tr><tr><td><label>Minimum Contribution To Claim</label><div class="currency"><input name="reward[][price]" type="text" /><span style="position:absolute">$</span></div><label>Title</label><input name="reward[][title]" type="text" /><br/><label>Image URL (optional)</label><input placeholder="http://www.host.com/image.jpg" name="reward[][image_url]" type="text" /><br/><label>Description</label><textarea name="reward[][description]"></textarea><br/><label>Estimated Delivery Date (i.e. May 2014)</label><input name="reward[][delivery_date]" type="text" /><br/><label>Number Available (leave blank if unlimited)</label><input name="reward[][number]" type="text" /><label>Collect shipping address for this reward?</label><input name="reward[][collect_shipping_flag]" type="checkbox" checked /></td><td>0</td><td><input type="checkbox" name="reward[][delete]" value="delete"/></td></tr></table></li>')

    $('.faq.sortable').sortable
      stop: (e, ui) ->
        iterator = 1
        $.each $('.faq.sortable li'), ->
          $this = $(this)
          $this.find('input[name="faq[][sort_order]"]').val(iterator)
          $this.find('span').html(iterator)
          iterator++

    $('#faq-add').on 'click', (e) ->
      e.preventDefault()
      $element = $('.faq.sortable li:last-child').clone()
      position = parseInt($element.find('span').html(), 10) + 1
      $element.find('span').html(position)
      $element.find('input[name="faq[][sort_order]"]').val(position)
      $element.find('textarea[name="faq[][question]"]').html('')
      $element.find('textarea[name="faq[][answer]"]').html('')
      $element.appendTo('.faq.sortable')

    $('.faq.sortable').on 'click', (e) ->
        $this = $(e.target)
        if $this.is('.faq-delete')
          e.preventDefault()
          $this.parent().remove()
          iterator = 1
          $.each $('.faq.sortable li'), ->
            $this = $(this)
            $this.find('span').html(iterator)
            $this.find('input[name="faq[][sort_order]"]').val(iterator)
            iterator++


    $('.refund-payment').on 'click', (e) ->
      row = $(this).parent().parent()
      cell = $(this).parent()
      paymentId = row.find('td.ct_payment_id').text()
      email = row.find('td.email').text()
      amount = parseFloat(row.find('td.amount').text().split('$')[1])
      user_fee_amount = parseFloat(row.find('td.user_fee_amount').text().split('$')[1])
      total = amount + user_fee_amount
      confirm = window.confirm("Are you sure you want to refund " + email + " for $" + total.toFixed(2) + "?")
      if (confirm)
        loader = row.find('td > .loader')
        loader.show() 
        status = row.find('td.status')
        origColor = row.find('td.ct_payment_id').css("background-color")
        $.post("/admin/payments/" + paymentId + "/refund")
          .done(() ->
            status.animate({
              backgroundColor: '#5cb85c'
            }, 400, 'swing', () ->
              $(this).animate({
                backgroundColor: origColor
              })
            ).text('refunded')
            cell.html('')
          )
          .fail(() ->
            status.animate({
              backgroundColor: '#d9534f'
            }, 300, 'swing')
            setTimeout(() ->
              alert('Sorry, this payment could not be refunded. These funds may have already been released to you. If you have any questions, please contact team@crowdhoster.com with the payment ID.')
            , 300)
          )
          .always(() ->
            loader.hide()
          )

  # Custom Named Functions
  checkSafety : (editor) ->
    reg = new RegExp(/(\s*[:]*?[=]?\s*["]?\s*\b(http)\s*:\s*\/\/[a-zA-Z0-9+&@#\/%?=~_-|!,;:.~-]*)/g)
    regDisp = new RegExp(/(\b(http)\s*:\s*\/\/[a-zA-Z0-9+&@#\/%?=~_-|!,;:.~-]*)/g)
    str = $("#" + editor).val()
    occ_msg = ""
    while (result = reg.exec(str)) isnt null
      occ_orig = str.split(result[1]).length - 1
      occ_href = str.split("href" + result[1]).length - 1
      if occ_orig isnt occ_href
        occ_msg =  occ_msg + "<strong>" + result[1].match(regDisp) + "</strong><br />"
    occ_msg

  checkSafetyAlert : (occ_msg, element, alertElement) ->
    if ( occ_msg != '' )
        $('#' + alertElement).html('It looks you are trying to load external content using insecure (non-HTTPS) links. Unless you change the following links to be served over HTTPS, your contributors will see a security warning in their browser.<br />' + occ_msg + '<br />If you need any help with this, please contact team@crowdhoster.com')
        $('#' + alertElement).slideDown()
        $('#' + element).addClass('text-area-border')
        Crowdhoster.admin.isSecurityCheckWarningDisplayed = false
      else
        $('#' + alertElement).slideUp()
        $('#' + element).removeClass('text-area-border')
        if( Crowdhoster.admin.checkSafety('settings_custom_css') == '' )
          $('#settings_custom_alert').hide();

  submitWebsiteForm: (form) ->
    form.submit()

  submitCampaignForm: (form) ->
    $date = $('#campaign_expiration_date')
    $date.val(new Date($date.val()).toUTCString())
    form.submit()

  submitBankForm: (form) ->
    $('#errors').html('')
    $('#bank_routing_number').removeAttr('name');
    $('#account_number').removeAttr('name');
    $form = $(form)

    userData =
      name: $form.find('#full_legal_name').val()
      phone: $form.find('#phone').val()
      street_address: $form.find('#street_address').val()
      postal_code: $form.find('#zip').val()
      dob: $form.find('#birth_year').val() + '-' + $form.find('#birth_month').val()

    $.ajax '/ajax/verify',
      type: 'POST'
      data: userData
      beforeSend: (jqXHR, settings) ->
        # Devise requires the CSRF token in order to still recognize the current user
        jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      success: (data) ->
        if(data == "success")
          Crowdhoster.admin.createBankAccount($form)
        else
          $('#errors').append('<p>An error occurred, please re-enter your account information</p>')
          $('.loader').hide()
          $('#bank_routing_number').attr('name', 'bank_routing_number');
          $('#account_number').attr('name', 'account_number');

  createBankAccount: ($form) ->
    bankData =
      account_number: $form.find('#account_number').val()
      name: $form.find('#full_legal_name').val()
      bank_code: $form.find('#bank_routing_number').val()

    errors={}
    if !crowdtilt.bank.validateUSARoutingNumber(bankData.bank_code)
      errors["bank_routing_number"] = "Invalid routing number"
    if bankData.account_number == ''
      errors["bank_account_number"] = "Invalid account number"

    if !$.isEmptyObject(errors)
      $.each errors, (index, value) ->
        $('#errors').append('<p>' + value + '</p>')
      $('.loader').hide()
      $('#bank_routing_number').attr('name', 'bank_routing_number');
      $('#account_number').attr('name', 'account_number');
    else
      user_id = $form.find('#ct_user_id').val()
      crowdtilt.bank.create(user_id, bankData, Crowdhoster.admin.bankResponseHandler)


  bankResponseHandler: (response) ->
    switch response.status
      when 201
        token = response.bank.id
        input = $('<input name="ct_bank_id" value="' + token + '" type="hidden" />');
        form = document.getElementById('admin_bank_form')
        form.appendChild(input[0])
        form.submit()
      else
        $('#errors').append('<p>An error occurred. Please try again.</p>')
        $('.loader').hide()
        $('#bank_routing_number').attr('name', 'bank_routing_number');
        $('#account_number').attr('name', 'account_number');
