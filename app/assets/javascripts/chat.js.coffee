class Timestamp extends Backbone.Model
  defaults:
    serverTime: 'Unknown'

  initialize: ->
    $.eventsource
      label: 'current-time'
      dataType: 'json'
      url: '/chat/stream'
      message: @messageReceived

  messageReceived: (data) =>
    serverTime = new Date data.timestamp
    @set('serverTime', serverTime)

class TimestampView extends Backbone.View
  tagName:   'p'
  className: 'pull-right navbar-text'

  template: JST['timestamp']

  initialize: ->
    @model.bind 'change', @render

  render: =>
    $(@el).html(@template(serverTime: @model.get('serverTime')))
    @

$ ->
  timestamp = new Timestamp
  timestampView = new TimestampView(model: timestamp)
  $('#timestamp-container').html(timestampView.render().el)
