window.Crowdhoster =

  init: ->
    $('.show_loader').on "click", ->
      $this = $(this)
      target = $this.attr('data-loader')
      $('.loader').filter('[data-loader="' + target + '"]').show()

    $('.show_tooltip').tooltip()

    $.fn.serializeObject = ->
      arrayData = @serializeArray()
      objectData = {}
      $.each arrayData, ->
        if @value?
          value = @value
        else
          value = ''

        if objectData[@name]?
          unless objectData[@name].push
            objectData[@name] = [objectData[@name]]

          objectData[@name].push value
        else
          objectData[@name] = value
      objectData

$ ->
  Crowdhoster.init()
  Crowdhoster.admin.init()
  Crowdhoster.campaigns.init()
  Crowdhoster.theme.init()

CKEDITOR.config.allowedContent = true
