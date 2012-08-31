class Chat.Views.TimestampView extends Backbone.View
  tagName:   'p'
  className: 'pull-right navbar-text'

  template: JST['timestamp']

  initialize: ->
    @model.bind 'change', @render

  render: =>
    $(@el).html(@template(model: @model))
    @
