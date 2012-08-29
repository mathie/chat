$ ->
  $.eventsource
    label: 'current-time'
    dataType: 'json'
    url: '/chat/stream'
    message: (data) ->
      serverTime = new Date data.timestamp
      $('#current-time').html(serverTime.toString())
