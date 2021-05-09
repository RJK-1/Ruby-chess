# frozen_string_literal: true

class Rook
  attr_reader :symbol, :colour, :moves
  attr_accessor :position

  def initialize(colour, index, position = nil)
    @colour = colour
    @symbol = "\u{265C}"
    @index = index
    @position = position.nil? ? get_position : position
    @moves = get_moves
  end

  def get_position
    if @colour == 'white'
      @index == 0 ? [7, 0] : [7, 7]
    else
      @index == 0 ? [0, 0] : [0, 7]
    end
  end

  def get_moves
    moves = []
    8.times { |i| moves << [position[0], i] }
    8.times { |i| moves << [i, position[1]] }
    @moves = moves
  end
    
end