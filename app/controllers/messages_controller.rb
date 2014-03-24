class MessagesController < ApplicationController
  respond_to :html

  def new

  end

  def create
    @message = Message.new(params[:message]) do |m|
      m.sender = current_user
      m.recipient = User.admin.first unless m.recipient_id.present?
    end

    if @message.save
      flash[:notice] = "Message successfully sent! Thanks."
      respond_with @message, location: feedback_path
    else
      render "feedback/index"
    end
  end
end
