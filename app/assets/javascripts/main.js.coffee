window.Selfstarter =

  init: ->
    $('.show_loader').on "click", ->
      $this = $(this)
      target = $this.attr('data-loader')
      $('.loader').filter('[data-loader="' + target + '"]').show()
    
    $('.show_tooltip').tooltip()

$ ->
  Selfstarter.init()
  Selfstarter.admin.init()
  Selfstarter.campaigns.init()
  Selfstarter.theme.init()
  
CKEDITOR.config.allowedContent = true

