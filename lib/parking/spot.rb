# frozen_string_literal: true

module Parking
  module Spot
    FREE = 0
    OCCUPIED = 1
    RESERVED = 2
    RESERVED_OCCUPIED = 3
  end
end

# Add some methos to integer for spots status management and drawing
class Integer
  def draw
    case self
    when Parking::Spot::OCCUPIED, Parking::Spot::RESERVED_OCCUPIED
      "#"
    when Parking::Spot::RESERVED
      "H"
    else
      " "
    end
  end

  def occup
    self + Parking::Spot::OCCUPIED
  end

  def free
    self - Parking::Spot::OCCUPIED
  end

  def free?
    self == Parking::Spot::FREE || self == Parking::Spot::RESERVED
  end

  def occupied?
    self == Parking::Spot::OCCUPIED || self == Parking::Spot::RESERVED_OCCUPIED
  end
end
