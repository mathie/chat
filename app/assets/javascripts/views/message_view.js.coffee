class Chat.Views.MessageView extends Backbone.View
  template: JST['messages/message']

  render: ->
    @$el.html(@template(model: @model))
    @
