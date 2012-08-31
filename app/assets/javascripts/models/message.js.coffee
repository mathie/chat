class Chat.Models.Message extends Chat.Models.Base
  defaults:
    createdAt: ->
      new Date
    message: "No message body"
