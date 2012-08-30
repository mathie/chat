window.Chat =
  Models: {}
  Views: {}
  Collections: {}

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

class Chat.Models.Message extends Chat.Models.Base
  defaults:
    createdAt: ->
      new Date
    message: "No message body"

class Chat.Collections.MessagesCollection extends Backbone.Collection
  model: Chat.Models.Message

  initialize: ->
    $.eventsource
      label: 'messages'
      dataType: 'json'
      url: '/chat/messages'
      message: @messageReceived

  messageReceived: (data) =>
    @add
      createdAt: new Date data.created_at
      message:   data.message

class Chat.Views.MessagesView extends Backbone.View
  template: JST['messages/collection']

  initialize: ->
    @collection.bind 'add', @render

  render: =>
    @$el.html(@template())
    @collection.each(@renderMessage)
    @

  renderMessage: (message) =>
    messageView = new Chat.Views.MessageView(model: message)
    $('#messages').prepend(messageView.render().el)

class Chat.Views.MessageView extends Backbone.View
  template: JST['messages/message']

  render: ->
    @$el.html(@template(model: @model))
    @

class Chat.Views.NewMessageView extends Backbone.View
  template: JST['messages/new']

  events:
    'submit #new-message-form': 'sendMessage'

  render: ->
    @$el.html(@template())
    @

  sendMessage: (e) ->
    console.log "Sending message"
    e.preventDefault()
    $.ajax
      url: '/messages'
      type: 'post'
      data: $(e.currentTarget).serialize()
      success: @messageSent

  messageSent: (data, status) ->
    console.log "Message sent"
    $('#new-message-form').each (_, form) => form.reset()

$ ->
  timestamp = new Chat.Models.Timestamp
  timestampView = new Chat.Views.TimestampView(model: timestamp)
  $('#timestamp-container').html(timestampView.render().el)

  newMessageView = new Chat.Views.NewMessageView
  $('#chat').html(newMessageView.render().el)

  messages = new Chat.Collections.MessagesCollection
  messagesView = new Chat.Views.MessagesView(collection: messages)
  $('#chat').append(messagesView.render().el)
