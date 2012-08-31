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
