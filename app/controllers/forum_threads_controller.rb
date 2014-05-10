class ForumThreadsController < ApplicationController
  layout "blank"

  before_filter :view_layout
  after_filter :allow_iframe, only: [:show]

  def show
    return if thread_id == 0

    thread = ForumThread.find_by uid: thread_id
    league_id = thread.league_id if thread

    unless league_id
      item = Item.find_by(thread_id: thread_id)
      league_id = item.league_id
    end

    @search = Search.new(
      league_id: league_id, thread_id: thread_id
    )

    @searchable = Elastic::ItemSearch.new(@search, params)
    @searchable.any_type = true
    @tire_search = @searchable.tire_search

    @results = ItemDecorator.decorate_collection(
      @tire_search.results
    )
  end

  private

  def thread_id
    params[:id].to_i
  end

  def allow_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM http://poearena.com'
  end

  def view_layout
    @layout = ViewLayout.new("s", "night")
  end

end
