require "spec_helper"

describe Mod do

  it "should find by mod" do
    examples = G_MODIFIERS.map do |base_mod|
      base_mod.gsub("#", rand(10).to_s)
    end

    Mod.stub(:find_by).and_return(mock({
      "value=" => 1
    }))

    examples.each do |example|
      Mod.find_by_item_mod(example).should_not == nil
    end
  end

end
