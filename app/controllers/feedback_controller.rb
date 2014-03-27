class FeedbackController < ApplicationController
  before_filter :view_layout

  def index
    @message = Message.new
  end
end
