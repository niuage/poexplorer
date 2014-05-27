module Concerns::Search
  extend ActiveSupport::Concern

  def search
    build_search

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
    @form = form_decorator_class.new(@search) unless request.xhr?

    session[:current_league_id] = @search.league_id
  end

  def update_from_url_params(search)
    name = params[:name]
    type = params[:item_type]
    rarity = params[:rarity]
    league = params[:league]
    linked_sockets = params[:linked_sockets]

    attrs = {}

    attrs.merge!({ rarity: find_rarity_by_name(rarity) }) unless rarity.nil?
    attrs.merge!({ league: find_league_by_name(league) }) unless league.nil?

    attrs.merge!({
      linked_socket_count: find_linked_sockets_count(linked_sockets),
      max_linked_socket_count: find_linked_sockets_count(linked_sockets)
    }) unless linked_sockets.nil?

    attrs.merge!({ base_name: name.empty? ? nil : name }) if valid_base_name?(name)
    attrs.merge!({ item_type: type.empty? ? nil : type }) unless type.nil?

    search.assign_attributes attrs
  end

  def find_search
    @search = typed_search.find_by(uid: params[:id])
    return redirect_to(root_url, notice: "This search could not be found, sorry.") unless @search
  end

  def find_league_by_name(league)
    if league.empty?
      League.find(current_league_id)
    else
      League.visible.where(name: league).first
    end
  end

  def find_rarity_by_name(rarity)
    rarity.empty? ? nil : Rarity.find_by(name: rarity.capitalize)
  end

  def find_linked_sockets_count(linked_sockets)
    linked_sockets.empty? ? nil : linked_sockets.to_i
  end

  def valid_base_name?(name)
    !name.nil? && (name.empty? || Item::BASE_NAMES.include?(name))
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
