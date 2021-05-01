# frozen_string_literal: true

require_relative '../lib/chess_game'

class ChessBoard
  def initialize
    @board = create_board
  end

  def create_board
    Array.new(8) { Array.new(8, ' ') }
  end

  def display_board
    @board.each do |row|
      print_row = []
      row.each do |cell|
        print_row << "|" + cell
      end
      print_row << "|"
      puts print_row.join
      

    end
  end
end