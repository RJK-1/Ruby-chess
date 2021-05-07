# frozen_string_literal: true

class King
  attr_reader :symbol, :colour, :moves
  attr_accessor :position
  
  def initialize(colour)
    @colour = colour
    @symbol = "\u{265A}"
    @position = get_position
    @moves = get_moves
  end

  def get_symbol
    @colour == 'white' ? "\u{2654}" : "\u{265A}"
  end

  def get_position
    @colour == 'white' ? @position = [7, 4] : @position = [0, 4]
  end

  def get_moves
    moves = []
    list = []
    moves << @position
    moves << [@position[0], @position[1] - 1]
    moves << [@position[0], @position[1] + 1]
    moves.each do |move|
      list << [move[0] + 1, move[1]]
      list << [move[0] - 1, move[1]]
    end
    list.each { |move| moves << move }
    moves.select! { |move| move[0] <= 7 && move[0] >= 0 && move[1] <= 7 && move[1] >= 0 }
    moves.delete(@position)
    @moves = moves
  end
end