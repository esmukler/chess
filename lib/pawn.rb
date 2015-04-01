# encoding: utf-8
class Pawn < Piece

  def initialize(board, color, pos, symbol)
    super(board, color, pos, symbol)
  end

  def all_moves
    # modify direction for black vs. white pieces
    modifier = color == :white ? -1 : 1
    legal_moves_array = []

    # one-square moves
    legal_moves_array << [1 * modifier + pos[0], pos[1]]

    # two-square moves only from the starting pos.
    if starting_pos?
      legal_moves_array << [2 * modifier + pos[0], pos[1]]
    end

    # filter moves for only squares on the board
    legal_moves_array.select! do |legal_pos|
      legal_pos[0].between?(0,7) && legal_pos[1].between?(0,7)
    end

    # only move to nil squares
    legal_moves_array.select!{|legal_pos| board[legal_pos].nil?}

    # add in possible attack moves
    all_moves = legal_moves_array.concat(attack_moves(modifier))

    all_moves
  end

  def pos_moves # used for checking for check
    modifier = color == :white ? -1 : 1
    attack_moves(modifier)
  end

  def legal_moves
    all_moves.select {|loc| !move_into_check?(loc) }
  end

  def starting_pos?
    if color == :black
      return pos[0] == 1
    else
      return pos[0] == 6
    end
  end

  def attack_moves(modifier)
    attack_moves = []

    attack_moves << [1 * modifier + pos[0], pos[1] + 1]
    attack_moves << [1 * modifier + pos[0], pos[1] - 1]

    attack_moves.select{ |loc| loc[1].between?(0,7) && loc[0].between?(0,7)}.select do |loca|
      !board[loca].nil? && board[loca].color != @color
    end
  end

  def move(end_pos)
    super(end_pos)

    # pawn promotion
    if @pos[0] == 7 && color == :black
      board[@pos] = SlidingPiece.new(@board, :black, pos, "\u{265B}", :rows, :cols, :diags)
    elsif @pos[0] == 0 && color == :white
      board[@pos] = SlidingPiece.new(@board, :white, pos, "\u{2655}", :rows, :cols, :diags)
    end
  end

end
