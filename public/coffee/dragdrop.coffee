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

        window.location = url
    )
