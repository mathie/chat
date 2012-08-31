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
