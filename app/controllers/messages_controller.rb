class MessagesController < ActionController::Base
  def create
    logger.info "Creating a new message: #{params[:message]}"
    payload = {
      message: params[:message],
      created_at: Time.now.utc
    }
    exchange = AMQP.channel.fanout('chat.messages', durable: true, auto_delete: false)
    exchange.publish payload.to_json, type: 'message'
    head :created
  end
end
