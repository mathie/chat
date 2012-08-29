require 'sinatra/base'

class ChatStream < Sinatra::Base
  configure do
    enable :logging
  end

  get '/stream' do
    stream(:keep_open) do |out|
      timer = EventMachine::PeriodicTimer.new(1) do
        logger.info "Sending some data"
        data = {
          timestamp: Time.now.utc
        }
        out << "data: #{data.to_json}\n\n"
      end

      out.errback do
        logger.info "Got an errback for"
        timer.cancel
      end

      out.callback do
        logger.info "Callback for out"
        timer.cancel
      end
    end
  end
end
