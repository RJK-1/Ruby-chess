# frozen_string_literal: true

require_relative '../lib/chess_board'
require_relative '../lib/chess_game'

board = ChessBoard.new
game = ChessGame.new(board)

board.display_board