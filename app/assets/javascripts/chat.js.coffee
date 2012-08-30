window.Chat =
  Models: {}
  Views: {}

class Chat.Models.Base extends Backbone.Model
  get: (attr) ->
    value = super
    if _.isFunction(value) then value.call(@) else value

class Chat.Models.Timestamp extends Chat.Models.Base
  defaults:
    serverTime: 'Unknown'
    clientToSinatraLatency: 0
    sinatraToBrowserLatency: 0
    clientToBrowserLatency: ->
      console.log "Called with #{@}"
      @get('clientToSinatraLatency') + @get('sinatraToBrowserLatency')

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
    @set('serverTime', serverTime)
    @set('clientToSinatraLatency', clientToSinatraLatency)
    @set('sinatraToBrowserLatency', sinatraToBrowserLatency)

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
