$ ->
  source = new EventSource('/chat/stream')
  source.addEventListener 'message', (e) ->
    data = JSON.parse(e.data)
    serverTime = new Date data.timestamp
    $('#current-time').html(serverTime.toString())
