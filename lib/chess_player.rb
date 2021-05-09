# frozen_string_literal: true

require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'
require 'colorize'


class ChessPlayer
  attr_reader :colour, :name
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
    if chosen_piece.instance_of?(Pawn) && [0, 7].include?(chosen_piece.position[0])
      chosen_piece = promote_pawn(chosen_piece)
    end
    chosen_piece
  end

  def promote_pawn(pawn)
    pieces = ['queen', 'rook', 'bishop', 'knight']
    puts 'What piece would you like to promote the pawn to? (Queen, Bishop, Rook, Knight)'.green.bold
    input = gets.chomp.downcase
    promote_pawn(pawn) if !pieces.include?(input)
    if input == 'queen'
      promoted = Queen.new(@colour, pawn.position)
      @pieces << promoted
    elsif input == 'knight'
      promoted = Knight.new(@colour, nil, pawn.position)
      @pieces << promoted
    elsif input == 'bishop'
      promoted = Bishop.new(@colour, nil, pawn.position)
      @pieces << promoted
    elsif input == 'rook'
      promoted = Rook.new(@colour, nil, pawn.position)
      @pieces << promoted
    end
    @pieces.delete(pawn)
    promoted
  end
end