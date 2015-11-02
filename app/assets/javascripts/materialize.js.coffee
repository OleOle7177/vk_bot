ready = ->
  # показывать loader и заблокировать все остальные действия 
  # при клике на кнопку 
  $('.notify').click -> 
    $('.content').addClass('overlay')
    $('.loader').show()
    return

$(document).ready(ready)
$(document).on('page:load', ready)

