# encoding: utf-8
require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'pawn'
require 'colorize'

class Board
  attr_accessor :rows

  def initialize(set = false)
    @rows = Array.new(8){Array.new(8)}
    set_board if set == true
  end

  def game_over?(color)
    return true if pieces().count <= 2
    pieces(:color => color).each do |piece|
      return false if piece.legal_moves.any?
    end
    true
  end

  def check_mate?(color)
    game_over?(color) && in_check?(color)
  end


  def in_check?(color)
    king = find_king(color)

    # check every piece of opposite color's legal moves
    pieces(:color => color, :opp => true).each do |piece|
      return true if piece.pos_moves.include?(king)
    end

    false
  end

  def find_king(color)
    pieces(:color => color).each {|piece| return piece.pos if piece.is_a?(King) }
  end

  def pieces(options = {})
    default = {:color => :all, :opp => false}
    options = default.merge(options)

    options[:color] = options[:color] == :black ? :white : :black if options[:opp]

    #flatten rows and select pieces (of color or opposite)
    @rows.flatten.select do |tile|
      !tile.nil? &&
      (tile.color == options[:color] || options[:color] == :all)
      end
  end

  def move(start_pos, end_pos, turn_color)
    raise ArgumentError.new("No piece at start position") if self[start_pos].nil?
    raise ArgumentError.new("Illegal move") if !self[start_pos].legal_moves.include?(end_pos)
    raise ArgumentError.new("Not your piece") if self[start_pos].color != turn_color

    self[start_pos].move(end_pos)
  end

  def dup
    dupe = Board.new

    pieces.each { |piece| dupe[piece.pos] = piece.dup(dupe) }

    dupe
  end

  def set_board
    create_rooks
    create_knights
    create_bishops
    create_queens
    create_kings
    create_pawns
  end

  def [](pos)
    x,y = pos[0], pos[1]
    @rows[x][y]
  end

  def []=(pos, value)
    x, y = pos[0], pos[1]
    @rows[x][y] = value
  end

  def create_rooks
    self[[0,0]] = SlidingPiece.new(self, :black, [0,0], "\u{265C}", :rows, :cols)
    self[[0,7]] = SlidingPiece.new(self, :black, [0,7], "\u{265C}", :rows, :cols)
    self[[7,0]] = SlidingPiece.new(self, :white, [7,0], "\u{2656}", :rows, :cols)
    self[[7,7]] = SlidingPiece.new(self, :white, [7,7], "\u{2656}", :rows, :cols)
  end

  def create_knights
    self[[0,1]] = Knight.new(self, :black, [0,1], "\u{265E}")
    self[[0,6]] = Knight.new(self, :black, [0,6], "\u{265E}")
    self[[7,1]] = Knight.new(self, :white, [7,1], "\u{2658}")
    self[[7,6]] = Knight.new(self, :white, [7,6], "\u{2658}")
  end

  def create_bishops
    self[[0,2]] = SlidingPiece.new(self, :black, [0,2], "\u{265D}", :diags)
    self[[0,5]] = SlidingPiece.new(self, :black, [0,5], "\u{265D}", :diags)
    self[[7,2]] = SlidingPiece.new(self, :white, [7,2], "\u{2657}", :diags)
    self[[7,5]] = SlidingPiece.new(self, :white, [7,5], "\u{2657}", :diags)
  end

  def create_queens
    self[[0,3]] = SlidingPiece.new(self, :black, [0,3], "\u{265B}", :rows, :cols, :diags)
    self[[7,3]] = SlidingPiece.new(self, :white, [7,3], "\u{2655}", :rows, :cols, :diags)
  end

  def create_kings
    self[[0,4]] = King.new(self, :black, [0,4], "\u{265A}")
    self[[7,4]] = King.new(self, :white, [7,4], "\u{2654}")
  end

  def create_pawns
    @rows[1].each_index {|col| self[[1, col]] = Pawn.new(self, :black, [1,col], "\u{265F}")}
    @rows[6].each_index {|col| self[[6, col]] = Pawn.new(self, :white, [6,col], "\u{2659}")}
  end

  def display_board
    puts
    shade = :light_red
    @rows.each_with_index do |array, row|
      puts "#{9 - row}" unless row == 0
      shade = shade == :light_red ? :light_white : :light_red
      array.each_index do |col|

        if self[[row,col]].nil?
          print "   ".colorize(:background => shade)
        else
          print " #{self[[row,col]].symbol} ".colorize(:background => shade)
        end
        shade = shade == :light_red ? :light_white : :light_red
      end
    end
    puts "1"
    puts " A  B  C  D  E  F  G  H  "
    nil
  end
  nil
end
