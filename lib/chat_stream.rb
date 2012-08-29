require 'sinatra/base'

class ChatStream < Sinatra::Base
  configure do
    enable :logging
  end

  get '/stream', provides: 'text/event-stream' do
    stream(:keep_open) do |out|
      timer = EventMachine::PeriodicTimer.new(1) do
        data = {
          timestamp: Time.now.utc
        }
        out << "data: #{data.to_json}\n\n"
      end

      out.callback do
        timer.cancel
      end
    end
  end
end
