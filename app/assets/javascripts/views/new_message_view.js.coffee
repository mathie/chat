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

  messageSent: (data, status) =>
    console.log "Message sent"
    $('#new-message-form').each (_, form) => form.reset()
