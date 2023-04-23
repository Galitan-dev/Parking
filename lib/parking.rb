# frozen_string_literal: true

require_relative "parking/version"
require_relative "parking/spot"
require_relative "parking/cards"

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
      @timestamps = []

      (0...@rows).each do
        (0...@columns).each do |col|
          @spots << (col.zero? ? Parking::Spot::RESERVED : Parking::Spot::FREE)
        end
      end
    end

    def index_of(col, row)
      row * @columns + col
    end

    def cost_for(col, row)
      elapsed = Time.now - @timestamps[index_of(col, row)]
      # 2€/h
      (elapsed / 30 * 10).floor
    end

    def occup(col, row, code, european_card = nil)
      index = index_of(col, row)
      throw Parking::Error.new("Spot occupied") if @spots[index].occupied?
      Parking::EuropeanCards.check(european_card) if @spots[index] == Parking::Spot::RESERVED
      @spots[index] = @spots[index].occup
      @codes[index] = code
      @timestamps[index] = Time.now
      puts self
    end

    def free(col, row, code, money)
      index = index_of(col, row)
      throw Parking::Error.new("Spot free") if @spots[index].free?
      throw Parking::Error.new("Wrong code") if code != @codes[index]
      cost = cost_for(col, row)
      throw Parking::Error.new("Insufficient money. You have to pay #{cost}€") if money < cost
      @spots[index] = @spots[index].free
      puts self
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
