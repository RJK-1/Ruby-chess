# frozen_string_literal: true

class Pawn
  attr_accessor :position
  attr_reader :symbol, :colour, :moves

  def initialize(colour, number)
    @colour = colour
    @symbol = "\u{265F}"
    @number = number
    @position = get_position
    @moves = get_moves
  end

  def get_symbol
    @colour == 'white' ? "\u{2659}" : "\u{265F}"
  end

  def get_position
    @colour == 'white' ? @position = [6, @number] : @position = [1, @number]
  end

  def get_moves
    if @colour == 'white'
      @position[0] == 6 ? @moves = [[5, @position[1]], [4, @position[1]]] : @moves = [[@position[0] - 1, position[1]]]
    else
      @position[0] == 1 ? @moves = [[2, @position[1]], [3, @position[1]]] : @moves = [[@position[0] + 1, position[1]]]
    end
  end
end