class Admin::MessagesController < Admin::AdminController
  def index
    @messages = Message.last(10)
  end

  def show
    @message = Message.find(params[:id])
  end
end
