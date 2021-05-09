# frozen_string_literal: true

class Knight
  attr_reader :symbol, :colour, :moves
  attr_accessor :position

  def initialize(colour, index, position = nil)
    @colour = colour
    @symbol = "\u{265E}"
    @index = index
    @position = position.nil? ? get_position : position
    @moves = get_moves
  end

  def get_position
    if @colour == 'white'
      @index == 0 ? [7, 1] : [7, 6]
    else
      @index == 0 ? [0, 1] : [0, 6]
    end
  end

  def get_moves
    action = [[2, 1], [1, 2]]
    moves = []
    moves << [@position[0] + action[0][0], @position[1] + action[0][1]]
    moves << [@position[0] + action[1][0], @position[1] + action[1][1]]
    moves << [@position[0] - action[0][0], @position[1] - action[0][1]]
    moves << [@position[0] - action[1][0], @position[1] - action[1][1]]
    moves << [@position[0] - action[0][0], @position[1] + action[0][1]]
    moves << [@position[0] - action[1][0], @position[1] + action[1][1]]
    moves << [@position[0] + action[0][0], @position[1] - action[0][1]]
    moves << [@position[0] + action[1][0], @position[1] - action[1][1]]
    moves.select! do |n|
      n[0] >= 0 && n[1] >= 0 && n[0] <= 7 && n[1] <= 7
    end
    @moves = moves
  end
end