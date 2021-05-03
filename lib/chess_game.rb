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
    play_game
  end

  def play_game(player = 'one')
    current_player = player == 'one' ? @player_one : @player_two
    @board.display_board
    selected_piece = select_piece(player)
    old_pos = selected_piece.position
    selected_piece.get_moves
    move = chose_move(player, selected_piece)
    current_player.make_move(selected_piece, move)
    @board.set_board(current_player, false, selected_piece, old_pos)
    player == 'one' ? play_game('two') : play_game('one')
  end

  def select_piece(player)
    puts "Player #{player.capitalize}, Please choose one of your pieces to move (e.g. A2)"
    input = gets.chomp.upcase.split('')
    if !input.join.match?(/^[A-H]{1}[0-8]{1}$/)
      select_piece(player)
    else
      start = [(input[0].ord-17).chr.to_i, (input[1].to_i) - 1]
      starting_piece = check_piece(start, player)
    end
  end

  def chose_move(player, piece)
    puts "Please choose where to move your piece (e.g. B2)"
    input = gets.chomp.upcase.split('')
    if !input.join.match?(/^[A-H]{1}[0-8]{1}$/)
      chose_move(player, piece) 
    else
      move = [(input[0].ord-17).chr.to_i, (input[1].to_i) - 1]
      verified_move = check_move(move, player, piece)
      p verified_move
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
    end

    verified_move if piece.moves.include? verified_move
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
    else
      nil
    end
    take_piece(verified_move, play)
    verified_move
  end

  def check_knight(move, play, piece)
    player = play == 'one' ? @player_one : @player_two
    prospective_move = @board.board[move[0]][move[1]]
    player_positions = []
    player.pieces.each { |piece| player_positions << piece.position }

    verified_move = move if piece.moves.include?(move) && prospective_move == ' '
    verified_move = move if piece.moves.include?(move) && prospective_move != ' ' && !player_positions.include?(move)
    take_piece(verified_move, play)  
    verified_move
  end

  def check_rook(move, play, piece)
    player = play == 'one' ? @player_one : @player_two
    enemy = play == 'one' ? @player_two : @player_one
    enemy_positions = []
    enemy.pieces.each { |piece| enemy_positions << piece.position }
    prospective_move = @board.board[move[0]][move[1]]
    all_free = false
    idx = nil
    piece.position[0] == move[0] ? idx = 1 : idx = 0
    number = piece.position[idx] < move[idx] ? piece.position[idx] + 1 : move[idx] + 1
    count = piece.position[idx] < move[idx] ? move[idx] - piece.position[idx] - 1 : piece.position[idx] - move[idx] - 1
    range = []
    count.times { range << number && number += 1 }
    if idx == 1
      all_free = range.all? { |val| @board.board[move[idx - 1]][val] == ' ' }
    elsif idx == 0
      all_free = range.all? { |val| @board.board[val][move[idx + 1]] == ' ' }
    end
    verified_move = move if all_free && (prospective_move == ' ' || enemy_positions.include?(move)) && piece.moves.include?(move)
    take_piece(verified_move, play)
    verified_move
  end

  def take_piece(verified_move, player)
    enemy = player == 'one' ? @player_two : @player_one
    enemy_pieces = []
    enemy.pieces.each { |piece| enemy_pieces << piece }

    enemy_pieces.map! do |piece|
      if piece.position == verified_move
        enemy.pieces.delete(piece)
      end
    end
  end
end