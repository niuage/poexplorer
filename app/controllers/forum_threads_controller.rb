class ForumThreadsController < ApplicationController
  layout :layout

  before_filter :view_layout
  after_filter :allow_iframe, only: [:show]

  def show
    return if thread_id == 0

    if request.xhr?
      sleep(3)
      @js = true

      thread = ForumThread.find_by uid: thread_id
      league_id = thread.league_id if thread

      return unless league_id

      search = Search.new(
        league_id: league_id, thread_id: thread_id
      )

      searchable = Elastic::ItemSearch.new(search, params)
      searchable.any_type = true
      tire_search = searchable.tire_search

      @results = ItemDecorator.decorate_collection(
        tire_search.results
      )
    end
  end

  private

  def thread_id
    @thread_id ||= params[:id].to_i
  end

  def allow_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM http://poearena.com'
  end

  def view_layout
    @layout = ViewLayout.new("s", "night")
  end

  def layout
    request.xhr? ? false : "blank"
  end

end
