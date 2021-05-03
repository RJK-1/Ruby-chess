# frozen_string_literal: true

require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'


class ChessPlayer
  attr_reader :colour
  attr_accessor :pieces

  def initialize(name, colour)
    @name = name
    @colour = colour
    @pieces = get_pieces
  end

  def get_pieces
    pieces = []
    8.times do |index|
      pieces << Pawn.new(@colour, index)
    end
    2.times do |index|
      pieces << Rook.new(@colour, index)
      pieces << Knight.new(@colour, index)
      pieces << Bishop.new(@colour, index)
    end
    pieces << King.new(@colour)
    pieces << Queen.new(@colour)
    pieces.flatten
  end

  def make_move(chosen_piece, move)
    @pieces.each do |piece|
      piece.position = [move[0], move[1]] if piece == chosen_piece
    end
  end
end