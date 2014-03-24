class SocketCollection
  SOCKET_EQUIVALENCES = { s: "r", d: "g", i: "b", g: "w" }

  attr_accessor :sockets

  def initialize(sockets = nil)
    @sockets = sockets || []
  end

  def linked_socket_count
    current_group = 0
    current_linked_socket_count = 0
    max_linked_socket_count = 0

    sockets.each do |socket|
      if group(socket) == current_group
        current_linked_socket_count += 1
      else
        current_linked_socket_count = 1
        current_group = group(socket)
      end

      if current_linked_socket_count > max_linked_socket_count
        max_linked_socket_count = current_linked_socket_count
      end
    end

    max_linked_socket_count
  end

  def socket_combination
    combination = ""
    current_group = 0

    sockets.each do |socket|
      if group(socket) != current_group
        current_group = group(socket)
        combination << " "
      end
      combination << socket_letter(socket)
    end

    return unless combination.present?
    SocketCollection.format_combination(combination)
  end

  def socket_count
    sockets.size
  end

  def self.create_socket_object_from_string(socket_string)
    socket_string = cleanup_combination(socket_string)
    current_group = 0
    sockets = []

    socket_string.each_char do |char|
      if char == " "
        current_group += 1
        next
      end

      sockets << {
        "group" => current_group,
        "attr" => socket_attribute(char)
      }
    end

    sockets
  end

  def self.format_combination(combination)
    return unless combination
    # rajouter \* quand jai gere la regexp
    cleanup_combination(combination)
      .split(" ")
      .map{ |str| str.chars.sort.join }
      .join(" ")
      # .sort_by(&:length)
      # .reverse!
  end

  def self.search_combination(combination)
    return if combination.blank?
    combination.split(" ").map do |linked_sockets|
      if linked_sockets.include?("*")
        match_all(linked_sockets.gsub("*", ""))
      else
        linked_sockets
      end
    end.join(" ").downcase
  end

  # private
  def self.match_all(string)
    match = string.scan(/((r|g|b|w)\2*)/).map(&:first).join("*")
    match = match.prepend("*") if match[0] != "b"
    match << "*" if match[-1, 1] != "r"
    match
  end

  # private
  def self.cleanup_combination(combination)
    combination.gsub(/[^rRgGbBwW\s]/, '').squish.downcase if combination
  end

  # private
  def self.socket_attribute(letter)
    attribute_pair = SOCKET_EQUIVALENCES.find { |k, v| v == letter }
    attribute_pair[0].to_s.upcase if attribute_pair
  end

  private

  def socket_letter(socket)
    SOCKET_EQUIVALENCES[socket["attr"].downcase.to_sym]
  end

  def group(socket)
    socket["group"].to_i
  end

end
