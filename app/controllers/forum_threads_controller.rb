class ForumThreadsController < ApplicationController
  layout :layout

  before_filter :view_layout
  after_filter :allow_iframe, only: [:show]

  def show
    return if thread_id == 0

    respond_to do |format|
      format.json do
        results = find_league ? tire_search.results : {}
        return render json: results, except: [
          :_score,
          :_type,
          :_index,
          :_version,
          :highlight,
          :_explanation,
          :sold,
          :rarity_id,
          :league_id
        ]
      end

      format.html do
        if request.xhr?
          @js = true

          if find_league
            @results = ItemDecorator.decorate_collection(tire_search.results)
          end

          return render :results
        end
      end
    end
  end

  private

  def find_league
    thread = ForumThread.find_by uid: thread_id
    @league_id = thread.league_id if thread
    @league_id
  end

  def tire_search
    return @tire_search if @tire_search

    search = Search.new(
      league_id: @league_id, thread_id: thread_id
    )

    searchable = Elastic::ItemSearch.new(search, params)
    searchable.any_type = true # is that necessary? cant I just check that it's just a Search object?
    @tire_search = searchable.tire_search
  end

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
