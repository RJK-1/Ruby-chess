# frozen_string_literal: true

require_relative '../lib/chess_board'

class ChessGame
  def initialize(board, p1, p2)
    @board = board
    @player_one = p1
    @player_two = p2
  end

  def start_game
    @board.set_board(@player_one, true)
    @board.set_board(@player_two, true)
    welcome_message
    play_game
  end

  def welcome_message
    puts 'Welcome to Chess!'.light_blue.bold
    puts 'Press S at any point to save'.light_blue
    puts 'All inputs are not case sensitive'.light_blue, ''
  end

  def play_game(player = 'one', reset = nil)
    current_player = player == 'one' ? @player_one : @player_two
    @board.display_board if reset == nil
    selected_piece = select_piece(player)
    old_pos = selected_piece.position
    selected_piece.get_moves
    move = chose_move(player, selected_piece)
    take_piece(move, player)
    current_player.make_move(selected_piece, move)
    selected_piece.get_moves
    @board.set_board(current_player, false, selected_piece, old_pos)
    check = check?(player)
    check_mate = check_mate?(player, selected_piece) if check
    puts "Check".red.bold if check && check_mate == false 
    if check_mate == false || check_mate == nil
      player == 'one' ? play_game('two') : play_game('one')
    elsif check_mate
      puts "Check Mate".red.bold
      end_game(player)
    end
  end

  def select_piece(player)
    puts "Player #{player.capitalize}, Please choose one of your pieces to move (e.g. A2)".light_black
    input = gets.chomp.upcase.split('')
    if !input.join.match?(/^[A-H]{1}[0-8]{1}$/)
      select_piece(player)
    else
      start = [(input[0].ord-17).chr.to_i, (input[1].to_i) - 1]
      starting_piece = check_piece(start, player)
      starting_piece.nil? ? select_piece(player) : starting_piece
    end
  end

  def chose_move(player, piece)
    puts "Please choose where to move your piece (e.g. B2) Press 'X' to change piece".light_black
    input = gets.chomp.upcase.split('')
    play_game(player, true) if input == ['X']
    if !input.join.match?(/^[A-H]{1}[0-8]{1}$/)
      chose_move(player, piece) 
    else
      move = [(input[0].ord-17).chr.to_i, (input[1].to_i) - 1]
      verified_move = check_move(move, player, piece)
      verified_move.nil? ? chose_move(player, piece) : verified_move
    end
  end

  def check_piece(start, player)
    player = player == 'one' ? @player_one : @player_two
    locations = []
    chosen_piece = nil
    player.pieces.each { |piece| locations << piece.position }
    if locations.include? start
      player.pieces.each do |piece|
        chosen_piece = piece if piece.position == start
      end
    end
    chosen_piece
  end

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
    verified_move if piece.moves.include? verified_move
    end
  end

  def check_pawn(move, play, piece)
    player = play == 'one' ? @player_one : @player_two
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

  def check_knight(move, play, piece)
    player = play == 'one' ? @player_one : @player_two
    prospective_move = @board.board[move[0]][move[1]]
    player_positions = []
    player.pieces.each { |piece| player_positions << piece.position }

    verified_move = move if piece.moves.include?(move) && prospective_move == ' '
    verified_move = move if piece.moves.include?(move) && prospective_move != ' ' && !player_positions.include?(move)
    verified_move
  end

  def check_rook(move, play, piece)
    enemy = play == 'one' ? @player_two : @player_one
    enemy_positions = []
    enemy.pieces.each { |piece| enemy_positions << piece.position }
    prospective_move = @board.board[move[0]][move[1]]
    step_list = get_steps(move, play, piece)
    all_free = step_list.all? { |val| @board.board[val[0]][val[1]] == ' ' }
    verified_move = move if all_free && (prospective_move == ' ' || enemy_positions.include?(move)) && piece.moves.include?(move)
    verified_move
  end

  def check_bishop(move, play, piece)
    player = play == 'one' ? @player_one : @player_two
    enemy = play == 'one' ? @player_two : @player_one
    enemy_positions = []
    enemy.pieces.each { |piece| enemy_positions << piece.position }
    prospective_move = @board.board[move[0]][move[1]]
    step_list = get_steps(move, play, piece)
    all_free = step_list.all? { |val| @board.board[val[0]][val[1]] == ' ' }
    verified_move = move if all_free && (prospective_move == ' ' || enemy_positions.include?(move)) && piece.moves.include?(move)
    verified_move
  end

  def get_steps(move, play, piece)
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

  def check_queen(move, play, piece)
    if move[0] == piece.position[0] || move[1] == piece.position[1]
      verified_move = check_rook(move, play, piece)
    else
      verified_move = check_bishop(move,play,piece)
    end
    verified_move
  end

  def check_king(move, play, piece)
    player = play == 'one' ? @player_one : @player_two
    enemy = play == 'one' ? @player_two : @player_one
    enemy_positions = []
    enemy_attacks = []
    enemy.pieces.each { |item| enemy_positions << item.position }
    enemy.pieces.each { |item| enemy_attacks << item if item.moves.include?(move) }
    enemy_attacks.each {|item| enemy_attacks.delete(item) if check_move(move, enemy, item) != move }

    verified_move = move if (@board.board[move[0]][move[1]] == ' ' || enemy_positions.include?(move)) && enemy_attacks.length == 0
    verified_move
  end

  def check?(play)
    enemy = play == 'one' ? @player_two : @player_one
    player = play == 'one' ? @player_one : @player_two
    enemy_king = nil
    player_pieces = []
    attacking_pieces = []
    check = false
    enemy.pieces.each { |piece| enemy_king = piece if piece.instance_of?(King) }
    player.pieces.each { |piece| player_pieces << piece }
    player_pieces.each { |piece| attacking_pieces << piece if piece.moves.include?(enemy_king.position) }
    attacking_pieces.each do |piece| 
      attacking_pieces.delete(piece) if check_move(enemy_king.position, play, piece) != enemy_king.position
    end
    check = true if attacking_pieces.length >= 1
    check
  end

  def check_mate?(play, piece)
    enemy = play == 'one' ? @player_two : @player_one
    player = play == 'one'? @player_one : @player_two
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
    step_list = get_steps(enemy_king.position, play, piece) 
    blocking_pieces = []
    step_list.each do |move|
      enemy_pieces.each { |item| blocking_pieces << item if item.moves.include?(move) && check_move(move, enemy, item) == move }
    end
    move_king && defending_pieces.length == 0 && blocking_pieces.length == 0 ? check_mate = true : check_mate = false
  end

  def end_game(player)
    puts "Player #{player} has won the game!"
    @board.display_board
  end

  def take_piece(verified_move, player)
    enemy = player == 'one' ? @player_two : @player_one
    enemy_pieces = []
    enemy.pieces.each { |piece| enemy_pieces << piece }
    enemy_pieces.each { |piece| enemy.pieces.delete(piece) if piece.position == verified_move }
  end
end