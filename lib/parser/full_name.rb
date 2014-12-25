module Parser::FullName
  extend ActiveSupport::Concern

  included do
    rule(:full_name_operator) do
      str("name:") >>
      (word_or_string).as(:full_name_operator)
    end
  end
end
