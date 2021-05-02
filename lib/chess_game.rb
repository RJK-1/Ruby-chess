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
    player = player == 'one' ? @player_one : @player_two
    other_player = player == 'one' ? @player_two : @player_one
    enemy_locations = []
    verified_move = nil
    if @board.board[move[0]][move[1]] == ' '
      verified_move = move
    else
      other_player.pieces.each { |piece| enemy_locations << piece.position }
      if enemy_locations.include? move
        verified_move = move
      else
        verified_move = nil
      end
    end
    p verified_move
    verified_move if piece.moves.include? verified_move
  end
end