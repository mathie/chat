EventMachine.next_tick do
  AMQP.channel ||= AMQP::Channel.new(AMQP.connection)
  AMQP.channel.fanout('chat.messages', durable: true, auto_delete: false)
end
