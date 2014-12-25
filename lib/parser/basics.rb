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
    def self.float_operator(attr)
      rule("#{attr}_operator".to_sym) do
        (
          (float_range | comparison_range).as(:range) >>
          space? >>
          str(attr.to_s).as(:attribute)
        ).as(:float_operator)
      end
    end
  end
end
