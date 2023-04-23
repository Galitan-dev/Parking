# frozen_string_literal: true

require_relative "parking/version"
require_relative "parking/spot"

module Parking
  class Error < StandardError; end

  # Main class
  class ParkingMetter
    attr_accessor :spots, :columns, :rows

    def initialize(columns: 10, rows: 6)
      @columns = columns
      @rows = rows
      @spots = []
      @codes = []

      (0...@rows).each do
        (0...@columns).each do |col|
          @spots << (col.zero? ? Parking::Spot::RESERVED : Parking::Spot::FREE)
        end
      end
    end

    def index_of(col, row)
      row * @columns + col
    end

    def occup(col, row, code)
      index = index_of(col, row)
      throw Parking::Error.new("Spot occupied") if @spots[index].occupied?
      @spots[index] = @spots[index].occup
      @codes[index] = code
    end

    def free(col, row, code)
      index = index_of(col, row)
      throw Parking::Error.new("Spot free") if @spots[index].free?
      throw Parking::Error.new("Wrong code") if code != @codes[index]
      @spots[index] = @spots[index].free
    end

    def draw_row(row)
      draw = ""
      draw += "\e[4m" if row.even?
      (0...@columns).each do |col|
        spot = @spots[index_of(col, row)]
        draw += "|" if col.zero?
        draw += "#{spot.draw}|"
      end
      draw += row.even? ? "\e[0m" : "\n"
      draw += "\n"
      draw
    end

    def to_s
      draw = ""
      (0...@rows).each do |row|
        draw += draw_row(row)
      end
      draw
    end
  end
end
