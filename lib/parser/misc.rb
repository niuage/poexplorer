module Parser::Misc
  extend ActiveSupport::Concern

  included do
    custom_float_operator(:quality) { str("%").maybe >> space? >> str("q") }

    rule(:thread_operator) do
      str("thread:") >> natural_number.as(:thread_id)
    end
  end
end
