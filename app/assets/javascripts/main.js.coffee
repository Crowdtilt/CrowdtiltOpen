window.Crowdhoster =

  init: ->
    $('.show_loader').on "click", ->
      $this = $(this)
      target = $this.attr('data-loader')
      $('.loader').filter('[data-loader="' + target + '"]').show()

    $('.show_tooltip').tooltip()

$ ->
  Crowdhoster.init()
  Crowdhoster.admin.init()
  Crowdhoster.campaigns.init()
  Crowdhoster.theme.init()

CKEDITOR.config.allowedContent = true
