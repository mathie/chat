window.Chat =
  Models: {}
  Views: {}

class Chat.Models.Base extends Backbone.Model
  get: (attr) ->
    value = super
    if _.isFunction(value) then value.call(@) else value

  inc: (attr, incrementBy = 1) ->
    @set(attr, @get(attr) + incrementBy)

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

class Chat.Views.TimestampView extends Backbone.View
  tagName:   'p'
  className: 'pull-right navbar-text'

  template: JST['timestamp']

  initialize: ->
    @model.bind 'change', @render

  render: =>
    $(@el).html(@template(model: @model))
    @

$ ->
  timestamp = new Chat.Models.Timestamp
  timestampView = new Chat.Views.TimestampView(model: timestamp)
  $('#timestamp-container').html(timestampView.render().el)
