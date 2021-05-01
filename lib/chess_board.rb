# frozen_string_literal: true

require_relative '../lib/chess_game'
require_relative '../lib/chess_player'

class ChessBoard
  def initialize
    @board = create_board
  end

  def create_board
    Array.new(8) { Array.new(8, ' ') }
  end

  def set_board(player)
    player.pieces.each do |piece|
      @board[piece.position[0]][piece.position[1]] = piece
    end
  end

  def display_board
    @board.each do |row|
      print_row = []
      row.each do |cell|
        cell == ' ' ? print_row << "|" + cell : print_row << "|" + cell.symbol    
      end
      print_row << "|"
      puts print_row.join
    end
  end

end
