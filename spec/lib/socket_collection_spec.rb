require "spec_helper"

describe SocketCollection do

  describe "#linked_socket_count" do

    it "should return 0 for an empty array or nil" do
      described_class.new([]).linked_socket_count.should == 0
      described_class.new(nil).linked_socket_count.should == 0
    end

    it "should return 1 for a 1L" do
      described_class.new([
        { "group" => "0", "attr" => "D" },
        { "group" => "1", "attr" => "S" },
        { "group" => "2", "attr" => "I" }
        ]).linked_socket_count.should == 1
    end

    it "should return 4 for a 4L" do
      described_class.new([
        { "group" => "0", "attr" => "D" },
        { "group" => "0", "attr" => "S" },
        { "group" => "1", "attr" => "I" },
        { "group" => "1", "attr" => "I" },
        { "group" => "1", "attr" => "I" },
        { "group" => "1", "attr" => "I" }
        ]).linked_socket_count.should == 4
    end

  end

  describe "#socket_combination" do

    it "should return nil for an item without sockets" do
      described_class.new([]).socket_combination.should == nil
    end

    it "should return g for a green(D) socket" do
      described_class.new([
        { "group" => "0", "attr" => "D" }
        ]).socket_combination.should == "g"
    end

    it "should return r for a red(S) socket" do
      described_class.new([
        { "group" => "0", "attr" => "S" }
        ]).socket_combination.should == "r"
    end

    it "should return b for a blue(I) socket" do
      described_class.new([
        { "group" => "0", "attr" => "I" }
        ]).socket_combination.should == "b"
    end

    it "should return rgbrg for an item with 5 linked sockets" do
      described_class.new([
        { "group" => "0", "attr" => "I" },
        { "group" => "1", "attr" => "S" },
        { "group" => "1", "attr" => "D" },
        { "group" => "1", "attr" => "I" },
        { "group" => "1", "attr" => "S" },
        { "group" => "1", "attr" => "D" }
        ]).socket_combination.should == "bggrr b"
    end

    it "should return the last group of linked sockets if several groups have the same length" do
      described_class.new([
        { "group" => "0", "attr" => "I" },
        { "group" => "1", "attr" => "S" },
        { "group" => "1", "attr" => "D" },
        { "group" => "2", "attr" => "I" },
        { "group" => "2", "attr" => "I" },
        { "group" => "3", "attr" => "S" }
        ]).socket_combination.should == "bb gr r b"
    end

  end

  # describe "self.combination_value" do

  #   it "should return nil for an invalid string or nil" do
  #     described_class.combination_value("qw").should == nil
  #     described_class.combination_value("").should == nil
  #     described_class.combination_value(nil).should == nil
  #   end

  #   it "should return 1 for a red socket" do
  #     described_class.combination_value("R").should == 1
  #   end

  #   it "should return 11 for a green socket" do
  #     described_class.combination_value("G").should == 11
  #   end

  #   it "should return 111 for a blue socket" do
  #     described_class.combination_value("B").should == 111
  #   end

  #   it "should add the values of individual sockets" do
  #     described_class.combination_value("RgB").should == 1 + 11 + 111
  #   end

  #   it "should should be greater than the value of 6 sockets of the previous color" do
  #     described_class.combination_value("G").should > described_class.combination_value("rrrrrr")
  #     described_class.combination_value("b").should > described_class.combination_value("gggGGG")
  #   end

  # end

  describe "#socket_count" do

    it "should return the length of the array" do
      described_class.new([]).socket_count.should == 0

      described_class.new([
        { "group" => "0", "attr" => "D" }
        ]).socket_count.should == 1

      described_class.new([
        { "group" => "0", "attr" => "D" },
        { "group" => "1", "attr" => "S" }
        ]).socket_count.should == 2
    end

  end

end
