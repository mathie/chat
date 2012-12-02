require 'sinatra/base'

class ChatStream < Sinatra::Base
  configure do
    enable :logging
  end

  post '/timestamp', provides: 'text/event-stream' do
    headers 'X-Accel-Buffering' => 'No'
    headers 'Access-Control-Allow-Origin' => '*'
    cache_control :no_cache

    stream(:keep_open) do |out|

      out << ':'
      out << ' ' * 2049
      out << "\n"
      out << "retry: 500\n"

      AMQP::Channel.new(AMQP.connection, auto_recovery: true) do |channel|
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

  post '/messages', provides: 'text/event-stream' do
    headers 'X-Accel-Buffering' => 'No'
    headers 'Access-Control-Allow-Origin' => '*'
    cache_control :no_cache

    stream(:keep_open) do |out|

      out << ':'
      out << ' ' * 2049
      out << "\n"
      out << "retry: 500\n"

      AMQP::Channel.new(AMQP.connection, auto_recovery: true) do |channel|
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
