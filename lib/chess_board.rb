# frozen_string_literal: true

require_relative '../lib/chess_game'
require_relative '../lib/chess_player'
require 'colorize'

class ChessBoard
  attr_accessor :board
  def initialize
    @board = create_board
  end

  def create_board
    Array.new(8) { Array.new(8, ' ') }
  end

  def set_board(player, initial = nil, piece = nil, old_pos = nil)
    if initial
      player.pieces.each do |piece|
        @board[piece.position[0]][piece.position[1]] = piece
      end
    else
      @board[old_pos[0]][old_pos[1]] = ' '
      @board[piece.position[0]][piece.position[1]] = piece
    end
  end

  def display_board
    puts '  1 2 3 4 5 6 7 8'.light_green
    letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
    count = 0
    @board.each do |row|
      print_row = []
      row.each do |cell|
        if cell != ' ' && cell != 'X'
          cell.colour == 'white' ? print_row << "|" + cell.symbol.white : print_row << "|" + cell.symbol.light_black
        else
          print_row << "|" + cell
        end
      end
      print_row << "|"
      print_row.unshift(letters[count].light_green)
      print_row << letters[count].light_green
      count += 1
      puts print_row.join
    end
    puts '  1 2 3 4 5 6 7 8'.light_green
  end

  def show_moves(piece) # currently redundant
    piece.moves.each do |move|
      @board[move[0]][move[1]] = 'X'
    end
    display_board
    piece.moves.each do |move|
      @board[move[0]][move[1]] = ' '
    end

  end
end
