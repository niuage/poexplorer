class GearValidator < ActiveModel::Validator
  def validate(gear)
    if gear.skill_gems.all?(&:marked_for_destruction?)
      gear.errors[:skill_gem_ids] << "Skill gems are required"
    end
  end
end
