# frozen_string_literal: true

class Queen
  attr_reader :symbol, :colour
  attr_accessor :position
  
  def initialize(colour)
    @colour = colour
    @symbol = "\u{265B}"
    @position = get_position
  end

  def get_symbol
    @colour == 'white' ? "\u{2655}" : "\u{265B}"
  end

  def get_position
    @colour == 'white' ? @position = [7, 3] : @position = [0, 3]
  end 
end