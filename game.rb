# encoding: utf-8
require_relative 'chess_board'
require_relative 'computer_player'

class Game
  attr_reader :board, :player1, :player2
  attr_accessor :turn

  def initialize
    @board = Board.new(true)
    get_players
    @turn = @player1
  end

  def get_players
    print "White Pieces: Human Player (y/n)?"
    p1 = gets.chomp.downcase

    print "Black Pieces: Human Player (y/n)?"
    p2 = gets.chomp.downcase

    create_players(p1, p2)
  end

  def create_players(p1, p2)
    @player1 = p1 == "y" ? HumanPlayer.new(:white) : ComputerPlayer.new(:white, board)

    @player2 = p2 == "y" ? HumanPlayer.new(:black) : ComputerPlayer.new(:black, board)
  end

  def play
    puts "Let's play chess!"
    until board.game_over?(turn.color)

      board.display_board
      begin
        puts "#{turn.color}'s move:"
        move = turn.get_move

        board.move(move[0], move[1], turn.color)

      rescue ArgumentError => e
        puts e
      retry
      end
      toggle_turn
    end

    board.display_board
    check_result
  end

  def toggle_turn
    @turn = @turn == @player1 ? @player2 : @player1
  end

  def check_result
    if board.check_mate?(turn.color)
      toggle_turn
      puts "CHECKMATE! #{turn.color} wins!"
    else
      puts "It's a stalemate!"
    end
    nil
  end

end

class HumanPlayer
  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def get_move
    puts"Choose Piece:(e.g. E2)"
    piece = gets.chomp
    piece = convert_input(piece)

    puts"Choose Move:(e.g. E4)"
    move = gets.chomp
    move = convert_input(move)

    [piece, move]
  end

  def convert_input(input)
    input = input.split("")

    input[0], input[1] = 8 - input[1].to_i, input[0].downcase.ord - 97

    input
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play
end
