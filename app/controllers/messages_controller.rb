class MessagesController < ActionController::Base
  def create
    logger.info "Creating a new message: #{params[:message]}"
    head :created
  end
end
