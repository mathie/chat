require 'sinatra/base'

$active_streams = 0

class ChatStream < Sinatra::Base
  def initialize(app = nil)
    super

    configure_amqp_queue
  end

  configure do
    enable :logging
  end

  get '/stream', provides: 'text/event-stream' do
    stream_number = $active_streams
    $active_streams += 1
    logger.info "GET /stream start [#{stream_number}]"
    stream(:keep_open) do |out|
      logger.info "[#{stream_number}] Stream opened."
      AMQP::Channel.new(@connection, auto_recovery: true) do |channel|
        logger.info "[#{stream_number}] Channel opened."
        channel.queue('', durable: false, auto_delete: true).bind('chat.stream').subscribe do |metadata, payload|
          logger.info "Payload received on stream #{stream_number}."
          data = {
            timestamp: Time.now.utc,
            metadata: metadata,
            payload: JSON.parse(payload)
          }
          out << "event: #{metadata.type}\n"
          out << "data: #{data.to_json}\n\n"
        end

        out.callback do
          $active_streams -= 1
          logger.info "Callback called, stream closed. channel #{channel.open? ? "open" : "closed"}. Active streams: #{$active_streams}. [#{stream_number}]"
          channel.close if channel.open?
        end
      end
    end
    logger.info "GET /stream finished [#{stream_number}]"
  end

  private
  def configure_amqp_queue
    @connection = AMQP.connect(host: '127.0.0.1')
  end
end
