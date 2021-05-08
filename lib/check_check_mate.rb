# frozen_string_literal: true

module CheckChecker
  def check?(player)
    enemy = player == @player_one ? @player_two : @player_one
    enemy_king = nil
    player_pieces = []
    attacking_pieces = []
    check = false
    enemy.pieces.each { |piece| enemy_king = piece if piece.instance_of?(King) }
    player.pieces.each { |piece| player_pieces << piece }
    player_pieces.each { |piece| attacking_pieces << piece if piece.moves.include?(enemy_king.position) }
    attacking_pieces.each do |piece| 
      attacking_pieces.delete(piece) if check_move(enemy_king.position, player, piece) != enemy_king.position
    end
    check = true if attacking_pieces.length >= 1
    check
  end

  def check_mate?(player, piece)
    enemy = player == @player_one ? @player_two : @player_one
    enemy_king = nil
    king_moves = []
    enemy_pieces = []
    player_pieces = []
    enemy.pieces.each { |piece| enemy_king = piece if piece.instance_of?(King) }
    enemy.pieces.each { |piece| enemy_pieces << piece if !piece.instance_of?(King) }
    player.pieces.each { |piece| player_pieces << piece }
    enemy_king.moves.each { |move| king_moves << move if check_move(move, enemy, enemy_king) == move }
    if king_moves.length > 0
      king_moves.each do |move|
        player_pieces.each do |piece|
          if piece.moves.include?(move)
            king_moves.delete(move) if check_move(move, player, piece) == move
          end
        end
      end
    end
    move_king = true if king_moves.length > 0
    defending_pieces = []
    protect_king = false
    enemy_pieces.each { |item| defending_pieces << item if item.moves.include?(piece.position) }
    defending_pieces.each { |item| defending_pieces.delete(item) if check_move(piece.position, enemy, item) != piece.position }
    step_list = get_steps(enemy_king.position, player, piece) 
    blocking_pieces = []
    step_list.each do |move|
      enemy_pieces.each { |item| blocking_pieces << item if item.moves.include?(move) && check_move(move, enemy, item) == move }
    end
    move_king && defending_pieces.length == 0 && blocking_pieces.length == 0 ? check_mate = true : check_mate = false
  end
end