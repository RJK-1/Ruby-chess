# frozen_string_literal: true

require_relative '../chess_board'

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

  def get_position
    @colour == 'white' ? @position = [6, @number] : @position = [1, @number]
  end

  def get_moves
    if @colour == 'white'
      @position[0] == 6 ? @moves = [[5, @position[1]], [5, @position[1] - 1], [5, @position[1] + 1], 
      [4, @position[1]]] : @moves = [[@position[0] - 1, position[1]], [@position[0] - 1, position[1] - 1], [@position[0] - 1, position[1] + 1] ]
    else
      @position[0] == 1 ? @moves = [[2, @position[1]], [2, @position[1] - 1], [2, @position[1] + 1], 
      [3, @position[1]]] : @moves = [[@position[0] + 1, position[1]], [@position[0] + 1, position[1] - 1], [@position[0] + 1, position[1] + 1] ]
    end
    @moves.select! { |move| move[0] >= 0 && move[0] <= 7 }
    @moves.select! { |move| move[1] >= 0 && move[1] <= 7 }
    moves
  end
end