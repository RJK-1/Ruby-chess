# frozen_string_literal: true

class Queen
  attr_reader :symbol, :colour, :moves
  attr_accessor :position
   
  def initialize(colour, position = nil)
    @colour = colour
    @symbol = "\u{265B}"
    @position = position.nil? ? get_position : position
    @moves = get_moves
  end

  def get_position
    @colour == 'white' ? @position = [7, 3] : @position = [0, 3]
  end 

  def get_moves
    moves = []
    current1 = @position
    current2 = @position
    current3 = @position
    current4 = @position
    until current1[0] >= 8 && current1[1] >= 8 do
      moves << current1
      current1 = [current1[0] + 1, current1[1] + 1]
    end
    until current2[0] >= 8 && current2[1] <= 8 do
      moves << current2
      current2 = [current2[0] + 1, current2[1] - 1]
    end
    until current3[0] <= 0 && current3[1] <= 0 do
      moves << current3
      current3 = [current3[0] - 1, current3[1] - 1]
    end
    until current4[0] <= 0 && current4[1] >= 8 do
      moves << current4
      current4 = [current4[0] - 1, current4[1] + 1]
    end
    8.times { |i| moves << [position[0], i] }
    8.times { |i| moves << [i, position[1]] }
    moves.uniq!
    moves.select! { |move| move[0] <= 7 && move[0] >= 0 && move[1] <= 7 && move[1] >= 0 }
    moves.delete(@position)
    @moves = moves
  end
end