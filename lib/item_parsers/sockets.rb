module ItemParsers
  class Sockets < Base
    search_attributes :socket_count,
                      :linked_socket_count,
                      :socket_combination

    def recognize?(section)
      search.has_sockets? && property_name(section[0]) == "Sockets"
    end

    def socket_count
      socket_collection.socket_count
    end

    def linked_socket_count
      socket_collection.linked_socket_count
    end

    def socket_combination
      socket_collection.socket_combination
    end

    private

    def socket_collection
      @_socket_collection ||= SocketCollection.new(socket_object)
    end

    def socket_object
      return unless (sockets = find_attribute_value("Sockets")).present?
      SocketCollection.create_socket_object_from_string(sockets)
    end
  end
end
