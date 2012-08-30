require 'sinatra/base'

class ChatStream < Sinatra::Base
  set connection: -> { AMQP.connect(host: '127.0.0.1') }

  configure do
    enable :logging
  end

  get '/timestamp', provides: 'text/event-stream' do
    stream(:keep_open) do |out|
      AMQP::Channel.new(settings.connection, auto_recovery: true) do |channel|
        channel.queue('', durable: false, auto_delete: true).bind('chat.timestamps').subscribe do |metadata, payload_json|
          payload = JSON.parse(payload_json)
          milliseconds = Time.now.utc.to_f * 1000.0
          data = {
            timestamp: Time.now.utc,
            milliseconds: milliseconds,
            latency: milliseconds - payload['milliseconds'],
            metadata: metadata,
            payload: payload
          }
          out << "event: #{metadata.type}\n"
          out << "data: #{data.to_json}\n\n"
        end

        out.callback do
          channel.close if channel.open?
        end
      end
    end
  end

  get '/messages', provides: 'text/event-stream' do
    stream(:keep_open) do |out|
      AMQP::Channel.new(settings.connection, auto_recovery: true) do |channel|
        channel.queue('', durable: false, auto_delete: true).bind('chat.messages').subscribe do |metadata, payload|
          out << "event: #{metadata.type}\n"
          out << "data: #{payload}\n\n"
        end

        out.callback do
          channel.close if channel.open?
        end
      end
    end
  end
end
