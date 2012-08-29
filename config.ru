# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'chat_stream'

map "/" do
  run Chat::Application
end

map "/chat" do
  run ChatStream
end
