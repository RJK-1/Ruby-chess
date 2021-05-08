# frozen_string_literal: true

require_relative 'chess_board'
require_relative 'save_load'
require_relative 'move_checker'
require_relative 'check_check_mate'
require 'colorize'

class ChessGame
  include SaveLoad
  include MoveChecker
  include CheckChecker

  def initialize(board, p1, p2)
    @board = board
    @player_one = p1
    @player_two = p2
    @move = 'one'
  end

  def start_game
    welcome_message
    input = gets.chomp.to_i
    load_game if input == 2
    @board.set_board(@player_one, true)
    @board.set_board(@player_two, true)
    play_game
  end

  def welcome_message
    puts 'Welcome to Chess!'.light_blue.bold
    puts 'Press 1 to start a new game, or 2 to load a save'.light_blue
    puts 'Press S at any point to save'.light_blue
    puts 'Inputs are not case sensitive'.light_blue, ''
  end

  def play_game(player = @player_one, reset = nil, check_status = false, attacking_piece = nil)
    other_player = player == @player_one ? @player_two : @player_one
    @move = player
    @board.display_board if reset == nil
    selected_piece = select_piece(player, check_status)
    old_pos = selected_piece.position
    selected_piece.get_moves
    move = chose_move(player, selected_piece, check_status, attacking_piece)
    take_piece(move, player)
    player.make_move(selected_piece, move)
    selected_piece.get_moves
    @board.set_board(player, false, selected_piece, old_pos)
    check = check?(player)
    check_mate = check_mate?(player, selected_piece) if check
    if check_mate == false || check_mate == nil
      if check
        player == @player_one ? play_game(@player_two, nil, true, selected_piece) : play_game(@player_two, nil, true, selected_piece)
      else
        player == @player_one ? play_game(@player_two) : play_game(@player_one)
      end
    elsif check_mate
      puts "Check Mate".red.bold
      end_game(player)
    end
  end

  def select_piece(player, check_status)
    puts "#{player.name}, Please choose one of your pieces to move (e.g. A2)".light_black
    puts "Check! Your king is under attack, you must either defend or move your king!".red.bold if check_status
    input = gets.chomp.upcase.split('')
    save_game if input == ['S']
    if !input.join.match?(/^[A-H]{1}[0-8]{1}$/)
      select_piece(player, check_status)
    else
      start = [(input[0].ord-17).chr.to_i, (input[1].to_i) - 1]
      starting_piece = check_piece(start, player)
      starting_piece.nil? ? select_piece(player, check_status) : starting_piece
    end
  end

  def chose_move(player, piece, check_status = nil, attacking_piece = nil)
    check = false
    enemy = player == @player_one ? @player_one : @player_two
    old_pos = piece.position
    puts "Please choose where to move your piece (e.g. B2) Press 'X' to change piece".light_black
    input = gets.chomp.upcase.split('')
    play_game(player, true, true, attacking_piece) if input == ['X']
    save_game if input == ['S']
    if !input.join.match?(/^[A-H]{1}[0-8]{1}$/)
      chose_move(player, piece) 
    else
      move = [(input[0].ord-17).chr.to_i, (input[1].to_i) - 1]
      verified_move = check_move(move, player, piece)
      p verified_move
      if check_status && !verified_move.nil?
        p "here"
        player.make_move(piece, verified_move)
        @board.set_board(player, false, piece, old_pos)
        not_allowed = check?(enemy)
        player.make_move(piece, old_pos)
        @board.set_board(player, false, piece, verified_move)  
        not_allowed ? check = true : check = false
      end
      puts "You can only move to defend the king".red if check == true
      !verified_move.nil? && check == false ? verified_move : chose_move(player, piece, check_status)
    end
  end

  def check_piece(start, player)
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

  def end_game(player)
    puts "#{player.name} has won the game!"
    @board.display_board
  end

  def take_piece(verified_move, player)
    enemy = player == @player_one ? @player_two : @player_one
    enemy_pieces = []
    enemy.pieces.each { |piece| enemy_pieces << piece }
    enemy_pieces.each { |piece| enemy.pieces.delete(piece) if piece.position == verified_move }
  end
end