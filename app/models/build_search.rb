class BuildSearch < ActiveRecord::Base
  include Extensions::Uid

  belongs_to :user

  belongs_to :build

  attr_accessible :order, :keywords, :life_type, :softcore, :hardcore, :pvp,
    :skill_gem_ids, :unique_ids, :klass_ids, :keystone_ids, :user_uid

  attr_accessor :include_drafts

  store :klass_ids, coder: JSON
  store :unique_ids, coder: JSON
  store :skill_gem_ids, coder: JSON
  store :keystone_ids, coder: JSON

  def klass_ids=(ids)
    write_attribute(:klass_ids, { ids: ids.map(&:to_i).delete_if(&:zero?) })
  end
  def klass_ids
    read_attribute(:klass_ids)[:ids]
  end

  def skill_gem_ids=(ids)
    write_attribute(:skill_gem_ids, { ids: ids.map(&:to_i).delete_if(&:zero?) })
  end
  def skill_gem_ids
    read_attribute(:skill_gem_ids)[:ids]
  end

  def unique_ids=(ids)
    write_attribute(:unique_ids, { ids: ids.map(&:to_i).delete_if(&:zero?) })
  end
  def unique_ids
    read_attribute(:unique_ids)[:ids]
  end

  def keystone_ids=(ids)
    write_attribute(:keystone_ids, { ids: ids.map(&:to_i).delete_if(&:zero?) })
  end
  def keystone_ids
    read_attribute(:keystone_ids)[:ids]
  end

end
