# frozen_string_literal: true

class King
  attr_reader :symbol
  attr_accessor :position
  
  def initialize(colour)
    @colour = colour
    @symbol = get_symbol
    @position = get_position
  end

  def get_symbol
    @colour == 'white' ? "\u{2654}" : "\u{265A}"
  end

  def get_position
    @colour == 'white' ? @position = [7, 4] : @position = [0, 4]
  end  
end