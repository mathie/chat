window.Chat =
  Models: {}
  Views: {}
  Collections: {}







$ ->
  timestamp = new Chat.Models.Timestamp
  timestampView = new Chat.Views.TimestampView(model: timestamp)
  $('#timestamp-container').html(timestampView.render().el)

  newMessageView = new Chat.Views.NewMessageView
  $('#chat').html(newMessageView.render().el)

  messages = new Chat.Collections.MessagesCollection
  messagesView = new Chat.Views.MessagesView(collection: messages)
  $('#chat').append(messagesView.render().el)
