module Parser::Basics
  extend ActiveSupport::Concern

  included do
    rule(:space) { match['\s\t'].repeat(1) }
    rule(:space?) { space.maybe }

    rule(:word) { match('\\w').repeat(1) }
    rule :string do
      str('"') >>
      ((str('\\') >> any) | (str('"').absent? >> any)).repeat.as(:string) >>
      str('"')
    end
    rule(:word_or_string) { word | string }
    rule(:anything) { match['^\s\t'].repeat(1) }

    rule(:comparison_range) do
      (
        comparison_operator.maybe.as(:comparison_operator) >>
        space? >>
        float.as(:float)
      ).as(:comparison_range)
    end

    # 12..15 dps
    # > 12 dps
    def self.float_operator(attr, &block)
      rule("#{attr}_operator".to_sym) do
        (
          attr_str = block_given? ? instance_eval(&block) : str(attr.to_s)
          range_or_comp >>
          space? >>
          attr_str.as(:attribute)
        ).as(:float_operator)
      end
    end

    def self.custom_float_operator(attr, &block)
      rule("#{attr}_operator".to_sym) do
        range_or_comp.as(:"#{attr}_operator") >> space? >> instance_eval(&block)
      end
    end

    def self.reverse_float_operator(attr, &block)
      rule("#{attr}_operator".to_sym) do
        (
          attr_str = block_given? ? instance_eval(&block) : str(attr.to_s)
          attr_str.as(:attribute) >>
          space? >>
          float_or_range
        ).as(:float_operator)
      end
    end
  end
end
