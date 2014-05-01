class ExileSearch < ActiveRecord::Base
  include Extensions::Uid

  belongs_to :user

  attr_accessible :keywords, :klass_ids, :unique_ids, :order

  store :klass_ids, coder: JSON
  store :unique_ids, coder: JSON

  def klass_ids=(ids)
    write_attribute(:klass_ids, { ids: ids.map(&:to_i).delete_if(&:zero?) })
  end
  def klass_ids
    read_attribute(:klass_ids)[:ids]
  end

  def unique_ids=(ids)
    write_attribute(:unique_ids, { ids: ids.map(&:to_i).delete_if(&:zero?) })
  end
  def unique_ids
    read_attribute(:unique_ids)[:ids]
  end

  def popular?
    order == "popular"
  end

  def recent?
    order.blank? || order == "recent"
  end
end
