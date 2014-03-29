module Concerns::Search
  extend ActiveSupport::Concern

  def search
    build_search
    session[:current_league_id] = @search.league_id

    @searchable = Elastic::ItemSearch.new(@search, params)
    @tire_search = @searchable.tire_search
    @results = ItemDecorator.decorate_collection(
      @tire_search.results,
      context: { size: layout_size }
    )
  end

  private

  def build_search
    unless @search
      @search = typed_search.new(params[:search])
      @search.league_id = @search.league_id.presence || current_league_id
    end

    update_from_url_params(@search)

    @search.stats.build unless @search.stats.any?
    @form = form_decorator_class.new(@search)
  end

  def update_from_url_params(search)
    name = params[:name]
    type = params[:item_type]
    rarity = params[:rarity]
    league = params[:league]
    linked_sockets = params[:linked_sockets]

    attrs = {}

    attrs.merge!({
      rarity: rarity.empty? ? nil : Rarity.find_by(name: rarity.capitalize)
    }) unless rarity.nil?

    attrs.merge!({
      league: league.empty? ? current_user.try(:league) : League.find_by(name: league)
    }) unless league.nil?

    unless linked_sockets.nil?
      linked_sockets_count = linked_sockets.empty? ? nil : linked_sockets.to_i
      attrs.merge!({
        linked_socket_count: linked_sockets_count,
        max_linked_socket_count: linked_sockets_count
      })
    end

    attrs.merge!({
      base_name: name.empty? ? nil : name
      }) if !name.nil? && (name.empty? || Item::BASE_NAMES.include?(name))

    attrs.merge!({ item_type: type.empty? ? nil : type }) unless type.nil?

    search.assign_attributes attrs
  end

  def find_search
    @search = typed_search.find_by(uid: params[:id])
    return redirect_to(root_url, notice: "This search could not be found, sorry.") unless @search
  end

  def search_params
    params[:search]
  end

  def typed_search
    WeaponSearch # ?
  end

  def form_decorator_class
    WeaponSearchFormDecorator
  end
end
