Crowdhoster.campaigns =

  init: ->

    _this = this

    this.timeCheck('#days')

    $("#video_image").on "click", ->
      $("#player").removeClass("hidden")
      $("#player").css('display', 'block')
      $(this).hide()

    # Checkout section functions:
    if($('#checkout').length)
      $('html,body').animate({scrollTop: $('#header')[0].scrollHeight})

    $('#quantity').on "change", (e) ->
      quantity = $(this).val()
      $amount = $('#amount')
      new_amount = parseFloat($amount.attr('data-original')) * quantity
      $amount.val(new_amount)
      $('#total').html(new_amount.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");)

    $('#amount').on "keyup", (e) ->
      $(this).addClass('edited')
      $('#amount').removeClass('error')
      $('.error').hide()

    $('.reward_option.active').on "click", (e) ->
      $this = $(this)
      if(!$(e.target).hasClass('reward_edit'))
        $amount = $('#amount')
        $this.find('input').prop('checked', true)
        $('.reward_option').removeClass('selected').hide()
        $this.addClass('selected').show()
        $('.reward_edit').show()
        $('html,body').animate({scrollTop: $('#checkout').offset().top});
        if(!$amount.hasClass('edited'))
          $amount.val($this.attr('data-price'))

    $('.reward_edit').on "click", (e) ->
      e.preventDefault()
      $('.reward_edit').hide()
      $('.reward_option').removeClass('selected').show()
      $('input').prop('checked', false)
      $('#amount').removeClass('error')
      $('.error').hide()
    
    $('#amount_form').on "submit", (e) ->
      e.preventDefault()
      $reward = $('.reward_option.selected')
      $amount = $('#amount')
      if($reward && $amount.val().length == 0)
        $amount.val($reward.attr('data-price'))
        this.submit()
      else if($reward && (parseFloat($reward.attr('data-price')) > parseFloat($amount.val())))
        $amount.addClass('error')
        $('.error').html('Amount must be at least $' + $reward.attr('data-price') + ' to select that ' + $('#reward_select').attr('data-reference') + '.').show()
      else
        this.submit()

  submitPaymentForm: (form) ->
    $('#refresh-msg').show()
    $('#errors').hide()
    $('#errors').html('')
    $('button[type="submit"]').attr('disabled', true).html('Processing, please wait...')
    $('#card_number').removeAttr('name')
    $('#security_code').removeAttr('name')

    $form = $(form)

    cardData =
      number: $form.find('#card_number').val().replace(/\s/g, "")
      expiration_month: $form.find('#expiration_month').val()
      expiration_year: $form.find('#expiration_year').val()
      security_code: $form.find('#security_code').val()
      postal_code: $form.find('#billing_postal_code').val()

    errors = crowdtilt.card.validate(cardData)
    if !$.isEmptyObject(errors)
      $.each errors, (index, value) ->
        $('#errors').append('<p>' + value + '</p>')
      Crowdhoster.campaigns.resetPaymentForm()
    else
      $.post($form.attr('data-user-create-action'), { email: $(document.getElementById('email')).val() })
      .done((user_id) ->
        $('#ct_user_id').val(user_id)
        crowdtilt.card.create(user_id, cardData, Crowdhoster.campaigns.cardResponseHandler)
      )
      .fail((jqXHR, textStatus) ->
        Crowdhoster.campaigns.resetPaymentForm()
        if jqXHR.status == 400
          $('#errors').append('<p>Sorry, we weren\'t able to process your contribution. Please try again.</p><br><p>If you continue to experience issues, please <a href="mailto:team@crowdhoster.com?subject=Support request for creating user payment">click here</a> to email support.</p>')
        else
          $('#errors').append('<p>Sorry, we weren\'t able to process your contribution. Please try again.</p><br><p>If you continue to experience issues, please <a href="mailto:team@crowdhoster.com?subject=Unable to create user payment">click here</a> to email support.</p>')
      )

  resetPaymentForm: (with_errors = true) ->
    $('#refresh-msg').hide()
    $('#errors').show() if with_errors
    $('.loader').hide()
    $button = $('button[type="submit"]')
    $button.attr('disabled', false).html('Confirm payment of $' + $button.attr('data-total'))
    $('#card_number').attr('name', 'card_number')
    $('#security_code').attr('name', 'security_code')

  timeCheck: (element) ->
    expiration = $(element).attr("date-element")          
    date_moment = moment.unix(expiration)
    expired = moment().diff(date_moment, "seconds") > 0
    if expired
      $(element).html  "No <span>days left!</span>"
      return
    months = date_moment.diff(moment(), "months")
    days = date_moment.diff(moment(), "days")
    refDate = "months"
    refDiff = months
    if days < 120
      hours = date_moment.diff(moment(), "hours")
      if hours > 72
        refDiff = days
        refDate = "days"
      else
        if hours >= 2
          refDiff = hours
          refDate = "hours"
        else
          refDiff = date_moment.diff(moment(), "minutes")
          refDate = "minutes"
    $(element).html refDiff + "<span style=\"width:100px\">" + refDate + " left</span>"
  
  cardResponseHandler: (response) ->
    form = document.getElementById('payment_form')
    request_id_token = response.request_id

    # store our new request_id
    previous_token_elem = $("input[name='ct_tokenize_request_id']")
    if (previous_token_elem.length > 0)
      previous_token_elem.attr('value', request_id_token)
    else
      request_input = $('<input name="ct_tokenize_request_id" value="' + request_id_token + '" type="hidden" />');
      form.appendChild(request_input[0])

    $('#client_timestamp').val((new Date()).getTime())
    switch response.status
      when 201
        card_token = response.card.id
        card_input = $('<input name="ct_card_id" value="' + card_token + '" type="hidden" />');
        form.appendChild(card_input[0])
        form.submit()
      else
        # show an error, re-enable the form submit button, save a record of errored payment
        $('#refresh-msg').hide()
        $('#errors').append('<p>An error occurred. Please check your credit card details and try again.</p><br><p>If you continue to experience issues, please <a href="mailto:team@crowdhoster.com?subject=Support request for a payment issue&body=PLEASE DESCRIBE YOUR PAYMENT ISSUES HERE">click here</a> to contact support.</p>')
        $('#errors').show()
        $('.loader').hide()
        $button = $('button[type="submit"]')
        $button.attr('disabled', false).html('Confirm payment of $' + $button.attr('data-total') )

        data = $(form).serializeObject()
        data.ct_tokenize_request_error_id = response.error_id
        # make sure we don't have sensitive info
        delete data.card_number
        delete data.security_code

        error_path = form.getAttribute('data-error-action')
        $.post(error_path, data)
