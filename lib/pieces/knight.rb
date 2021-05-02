# frozen_string_literal: true

class Knight
  attr_reader :symbol, :colour
  attr_accessor :position

  def initialize(colour, index)
    @colour = colour
    @symbol = "\u{265E}"
    @index = index
    @position = get_position
  end

  def get_symbol
    @colour == 'white' ? "\u{2658}" : "\u{265E}"
  end

  def get_position
    if @colour == 'white'
      @index == 0 ? [7, 1] : [7, 6]
    else
      @index == 0 ? [0, 1] : [0, 6]
    end
  end
end