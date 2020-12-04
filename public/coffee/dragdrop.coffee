class @Dragdrop
  constructor: ->
    $('.js-draggable').draggable(
      # revert: true
      revertDuration: 200
    )

    $('.js-droppable').droppable(
      accept: '.js-draggable'
      tolerance: 'intersect'
      drop: (e, ui) ->
        $slot     = $(this)
        $battery  = ui.draggable
        batteryId = $battery.data('id')

        url = $slot.data('accept-url')
        url = url.replace(':battery_id', batteryId)

        if $slot.hasClass('battery-item') && confirm("Vyměnit baterii #{$slot.find('.battery-name').text()}?")
          window.location = url
        else if !$slot.hasClass('battery-item')
          window.location = url
    )
