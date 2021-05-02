# frozen_string_literal: true

class Rook
  attr_reader :symbol, :colour
  attr_accessor :position

  def initialize(colour, index)
    @colour = colour
    @symbol = "\u{265C}"
    @index = index
    @position = get_position
  end

  def get_symbol
    @colour == 'white' ? "\u{2656}" : "\u{265C}"
  end

  def get_position
    if @colour == 'white'
      @index == 0 ? [7, 0] : [7, 7]
    else
      @index == 0 ? [0, 0] : [0, 7]
    end
  end
end