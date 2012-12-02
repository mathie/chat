class Chat.Collections.MessagesCollection extends Backbone.Collection
  model: Chat.Models.Message

  initialize: ->
    eventsource = new EventSource('/chat/messages')
    eventsource.addEventListener 'message', @messageReceived
    eventsource.addEventListener 'open', (e) ->
      console.log 'Message connection opened'
      console.log e
    eventsource.addEventListener 'error', (e) ->
      console.log 'Message connection error:'
      console.log e

  messageReceived: (e) =>
    console.log "Message message received."
    console.log e

    data = JSON.parse(e.data)
    @add
      createdAt: new Date data.created_at
      message:   data.message
