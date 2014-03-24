module Extensions
  module SocketCombination
    extend ActiveSupport::Concern

    included do
      attr_accessible :socket_combination

      before_save         :format_socket_combination, if: :format_socket_combination?
      before_save         :set_socket_combination,    if: :set_socket_combination?
    end

    def format_socket_combination?
      has_sockets? && (socket_combination_changed? || socket_store_changed?)
    end
    def format_socket_combination
      self.socket_combination = SocketCollection.format_combination(socket_combination)
    end

    def set_socket_combination?
      has_sockets? && socket_combination.blank?
    end
    def set_socket_combination
      self.socket_combination = SocketCollection.new(sockets).socket_combination
    end

  end
end
