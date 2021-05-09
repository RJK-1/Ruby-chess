# frozen_string_literal: true

module MoveChecker

  def check_move(move, player, piece)
    if piece.instance_of? Pawn
      verified_move = check_pawn(move, player, piece)
    elsif piece.instance_of? Knight
      verified_move = check_knight(move, player, piece)
    elsif piece.instance_of? Rook
      verified_move = check_rook(move, player, piece)
    elsif piece.instance_of? Bishop
      verified_move = check_bishop(move, player, piece)
    elsif piece.instance_of? Queen
      verified_move = check_queen(move, player, piece)
    elsif piece.instance_of? King
      verified_move = check_king(move, player, piece)
    end
    verified_move if piece.moves.include? verified_move
  end

  def check_pawn(move, player, piece)
    prospective_move = @board.board[move[0]][move[1]]
    player_positions = []
    player.pieces.each { |piece| player_positions << piece.position }
    if prospective_move == ' ' && move[1] == piece.position[1]
      verified_move = move
    elsif prospective_move != ' ' && move[1] != piece.position[1] && !player_positions.include?(move)
      verified_move = move
    end
    verified_move
  end

  def check_knight(move, player, piece)
    prospective_move = @board.board[move[0]][move[1]]
    player_positions = []
    player.pieces.each { |piece| player_positions << piece.position }

    verified_move = move if piece.moves.include?(move) && prospective_move == ' '
    verified_move = move if piece.moves.include?(move) && prospective_move != ' ' && !player_positions.include?(move)
    verified_move
  end

  def check_rook(move, player, piece)
    enemy = player == @player_one ? @player_two : @player_one
    enemy_positions = []
    enemy.pieces.each { |piece| enemy_positions << piece.position }
    prospective_move = @board.board[move[0]][move[1]]
    step_list = get_steps(move, player, piece)
    all_free = step_list.all? { |val| @board.board[val[0]][val[1]] == ' ' }
    verified_move = move if all_free && (prospective_move == ' ' || enemy_positions.include?(move))
    verified_move
  end

  def check_bishop(move, player, piece)
    enemy = player == @player_one ? @player_two : @player_one
    enemy_positions = []
    enemy.pieces.each { |piece| enemy_positions << piece.position }
    prospective_move = @board.board[move[0]][move[1]]
    step_list = get_steps(move, player, piece)
    all_free = step_list.all? { |val| @board.board[val[0]][val[1]] == ' ' }
    verified_move = move if all_free && (prospective_move == ' ' || enemy_positions.include?(move))
    verified_move
  end

  def check_queen(move, player, piece)
    if move[0] == piece.position[0] || move[1] == piece.position[1]
      verified_move = check_rook(move, player, piece)
    else
      verified_move = check_bishop(move, player, piece)
    end
    verified_move
  end

  def check_king(move, player, piece)
    enemy = player == @player_one ? @player_two : @player_one
    enemy_positions = []
    enemy_attacks = []
    enemy.pieces.each { |item| enemy_positions << item.position }
    enemy.pieces.each { |item| enemy_attacks << item if item.moves.include?(move) }
    enemy_attacks.each {|item| enemy_attacks.delete(item) if check_move(move, enemy, item) != move }

    verified_move = move if (@board.board[move[0]][move[1]] == ' ' || enemy_positions.include?(move)) && enemy_attacks.length == 0
    verified_move
  end

  def get_steps(move, player, piece)
    step = [0, 0]
    step_list = []
    current_step = piece.position
    if piece.position[0] != move[0] && piece.position[1] != move[1]
      move[0] > piece.position[0] ? step[0] = 1 : step[0] = -1
      move[1] > piece.position[1] ? step[1] = 1 : step[1] = -1
    else
      step[0] = 0 if move[0] == piece.position[0]
      step[0] = 1 if move[0] > piece.position[0]
      step[0] = -1 if move[0] < piece.position[0]
      step[1] = 0 if move[1] == piece.position[1]
      step[1] = 1 if move[1] > piece.position[1]
      step[1] = -1 if move[1] < piece.position[1]
    end
    until step_list[-1] == move do
      step_list << current_step
      current_step = [current_step[0] + step[0], current_step[1] + step[1]]
    end
    step_list = step_list[1..-2]
  end
end