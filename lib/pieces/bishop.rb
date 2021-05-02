# frozen_string_literal: true

class Bishop
  attr_reader :symbol, :colour
  attr_accessor :position

  def initialize(colour, index)
    @colour = colour
    @symbol = "\u{265D}"
    @index = index
    @position = get_position
    @moves = get_moves
  end

  def get_symbol
    @colour == 'white' ? "\u{2657}" : "\u{265D}"
  end

  def get_position
    if @colour == 'white'
      @index == 0 ? [7, 2] : [7, 5]
    else
      @index == 0 ? [0, 2] : [0, 5]
    end
  end

  def get_moves
  end
end