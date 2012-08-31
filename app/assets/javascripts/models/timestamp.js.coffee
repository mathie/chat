class Chat.Models.Timestamp extends Chat.Models.Base
  defaults:
    serverTime: 'Unknown'
    clientToSinatraLatency: 0
    sinatraToBrowserLatency: 0
    totalClientToSinatraLatency: 0
    totalSinatraToBrowserLatency: 0
    messageCount: 0
    clientToBrowserLatency: ->
      @get('clientToSinatraLatency') + @get('sinatraToBrowserLatency')
    averageSinatraToBrowserLatency: ->
      @get('totalSinatraToBrowserLatency') / @get('messageCount')
    averageClientToSinatraLatency: ->
      @get('totalClientToSinatraLatency') / @get('messageCount')
    averageClientToBrowserLatency: ->
      @get('averageSinatraToBrowserLatency') + @get('averageClientToSinatraLatency')

  initialize: ->
    $.eventsource
      label: 'timestamp'
      dataType: 'json'
      url: '/chat/timestamp'
      message: @messageReceived

  messageReceived: (data) =>
    serverTime = new Date data.timestamp
    clientToSinatraLatency = data.latency
    sinatraToBrowserLatency = (new Date).getTime() - data.milliseconds
    @addTimestamp(serverTime, clientToSinatraLatency, sinatraToBrowserLatency)

  addTimestamp: (serverTime, clientToSinatraLatency, sinatraToBrowserLatency) ->
    @inc('messageCount')
    @set('serverTime', serverTime)
    @set('clientToSinatraLatency', clientToSinatraLatency)
    @set('sinatraToBrowserLatency', sinatraToBrowserLatency)

    @inc('totalClientToSinatraLatency', clientToSinatraLatency)
    @inc('totalSinatraToBrowserLatency', sinatraToBrowserLatency)
