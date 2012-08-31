class Chat.Models.Base extends Backbone.Model
  get: (attr) ->
    value = super
    if _.isFunction(value) then value.call(@) else value

  inc: (attr, incrementBy = 1) ->
    @set(attr, @get(attr) + incrementBy)
