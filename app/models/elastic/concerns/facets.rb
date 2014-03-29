module Elastic::Concerns::Facets
  extend ActiveSupport::Concern

  def facets
    context.facet "rarity" do
      terms :rarity_name
    end

    context.facet "linked_sockets" do
      terms :linked_socket_count
    end

    context.facet "item_type" do
      terms :item_type, size: 5
    end

    context.facet "name" do
      terms :base_name, size: 5
    end
  end
end
