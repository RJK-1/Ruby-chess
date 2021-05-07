# frozen_string_literal: true

class Bishop
  attr_reader :symbol, :colour, :moves
  attr_accessor :position

  def initialize(colour, index)
    @colour = colour
    @symbol = "\u{265D}"
    @index = index
    @position = get_position
    @moves = get_moves
  end

  def get_symbol
    @colour == 'white' ? "\u{2657}" : "\u{265D}"
  end

  def get_position
    if @colour == 'white'
      @index == 0 ? [7, 2] : [7, 5]
    else
      @index == 0 ? [0, 2] : [0, 5]
    end
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
    moves.uniq!
    moves.select! { |move| move[0] <= 7 && move[0] >= 0 && move[1] <= 7 && move[1] >= 0 }
    moves.delete(@position)
    @moves = moves
  end
end