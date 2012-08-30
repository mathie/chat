class TimestampView extends Backbone.View
  tagName:   'p'
  className: 'pull-right navbar-text'

  template: JST['timestamp']

  initialize: ->
    @serverTime = "Unknown"

    console.log "Initialising"
    $.eventsource
      label: 'current-time'
      dataType: 'json'
      url: '/chat/stream'
      message: @message

  message: (data) =>
    @serverTime = new Date data.timestamp
    @render()

  render: ->
    $(@el).html(@template(serverTime: @serverTime))
    @

$ ->
  window.timestampView = new TimestampView
  $('#timestamp-container').html(timestampView.render().el)
