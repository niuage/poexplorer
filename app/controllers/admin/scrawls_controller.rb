class Admin::ScrawlsController < Admin::AdminController
  respond_to :html

  def index
    @scrawls = Scrawl.order("updated_at DESC").last(50)
    respond_with @scrawls
  end
end
