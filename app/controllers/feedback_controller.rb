class FeedbackController < ApplicationController
  def index
    @message = Message.new
  end
end
