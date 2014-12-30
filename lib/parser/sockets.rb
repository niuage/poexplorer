module Parser::Sockets
  extend ActiveSupport::Concern

  included do
    rule(:socket_color) { match['rgbw'] }
    rule(:item_color) { socket_color.repeat(1) }
    rule(:string_color) do
      str('"') >>
      (item_color >> space?).repeat(1).as(:color) >>
      str('"')
    end

    rule(:socket_digit) { match['123456'] }

    rule(:socket_count) { socket_digit.as(:count) >> str("s") }
    rule(:linked_socket_count) { (socket_digit.as(:count) >> str("l")) }

    custom_float_operator(:socket_count) { str("s") }
    custom_float_operator(:linked_socket_count) { str("l") }

    rule(:socket_operator) do
      socket_count_operator |
      linked_socket_count_operator
    end

    rule(:color_operator) do
      (
        ((str("color") >> str("s").maybe) | str("col")) >> str(":") >>
        (item_color.as(:color) | string_color)
      ).as(:color_operator)
    end
  end
end
