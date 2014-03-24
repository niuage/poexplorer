namespace :generate do

  task :socket_combination => :environment do
    count = Item.count
    current_item_index = 0
    prev_percentage = -1
    Item.find_each do |item|
      if !item.has_sockets? || item.socket_combination.present?
        item.update_attribute(:socket_combination, SocketCollection.new(item.sockets).socket_combination)
        current_item_index += 1
        current_percentage = ((current_item_index.to_f / count)*100).to_i
        puts current_percentage if current_percentage != prev_percentage
        prev_percentage = current_percentage
      end
    end
  end


end

