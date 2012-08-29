require 'sinatra/base'

class ChatStream < Sinatra::Base
  configure do
    enable :logging
  end

  get '/stream' do
    stream do |out|
      100.times do |i|
        out << "Got #{i}\n"
        sleep 0.1
      end
    end
  end
end
