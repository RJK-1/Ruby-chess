# frozen_string_literal: true

class Pawn
  attr_accessor :position
  attr_reader :symbol

  def initialize(colour, number)
    @colour = colour
    @symbol = get_symbol
    @number = number
    @position = get_position
  end

  def get_symbol
    @colour == 'white' ? "\u{2659}" : "\u{265F}"
  end

  def get_position
    @colour == 'white' ? @position = [6, @number] : @position = [1, @number]
  end
end