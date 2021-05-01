# frozen_string_literal: true

require_relative '../lib/chess_board'

class ChessGame
  def initialize(board, p1, p2)
    @board = board
    @player_one = p1
    @player_two = p2
  end

  def play_game
    set_board
  end

  def set_board
    @board.set_board(@player_one)
    @board.set_board(@player_two)
  end
end