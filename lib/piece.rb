# encoding: utf-8
class Piece
  attr_accessor :symbol, :color, :pos, :board
  def initialize(board, color, pos, symbol)
    @board = board
    @color = color
    @pos = pos
    @symbol = symbol
  end

  def move(end_pos)
    board[pos] , board[end_pos] = nil, self
    self.pos = end_pos
  end

  def move_into_check?(end_pos)
    dupe = board.dup

    dupe[@pos].move(end_pos)

    dupe.in_check?(color)
  end

  def dup(new_board)
    dup_piece = self.class.new(new_board, color, pos, symbol)
  end
end
