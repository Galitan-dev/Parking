# frozen_string_literal: true

module Parking
  # Simulate European Cards validation
  module EuropeanCards
    VALID_CARDS = [
      "1402 1502 1592 1902",
      "0927 1763 1603 1223",
      "2693 1693 1633 1603",
      "5923 2039 8735 7645"
    ].freeze

    def check(european_card)
      if european_card.nil?
        throw Parking::Error.new("This spot is reserved for people with disabilities")
      elsif !Parking::EuropeanCards::VALID_CARDS.include?(european_card)
        throw Parking::Error.new("Invalid European Card")
      end
    end

    module_function :check
  end
end
