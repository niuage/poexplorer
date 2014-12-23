object false

node(:total_count) { |m| @results.total_count }

child(@results, object_root: false) do |results|
  attributes *results.first.to_hash.keys if results.any?
end

