# frozen_string_literal: true

require_relative '../lib/chess_board'
require_relative '../lib/chess_game'
require_relative '../lib/chess_player'

board = ChessBoard.new
p1 = ChessPlayer.new('Player 1', 'white')
p2 = ChessPlayer.new('Player 2', 'black')
game = ChessGame.new(board, p1, p2)

game.set_board
board.display_board