class ComputerPlayer
  attr_accessor :color

  def initialize(color, board)
    @board = board
    @color = color
  end

  def get_move
    get_legal_moves

    test_mate = find_checkmate
    return test_mate unless test_mate.nil?

    return sample_capture unless sample_capture.nil?

    select_random_move
  end

  def get_legal_moves
    @legal_moves = Hash.new{|h,k| h[k] = []}
    @board.pieces(:color => @color).each do |piece|
      next if piece.legal_moves.empty?
      @legal_moves[piece.pos] = piece.legal_moves
    end
  end

  def select_random_move
    pos = @legal_moves.keys.sample
    move = @legal_moves[pos].sample
    [pos, move]
  end

  def sample_capture
    captures = []
    @legal_moves.each do |pos, moves_arr|
      next if moves_arr.empty?
      moves_arr.each do |end_move|
        next if @board[end_move].nil?
        if @board[end_move].class == SlidingPiece
          captures.unshift([pos, end_move])
        else
          captures << [pos, end_move]
        end
      end
    end
    captures.first
  end


  def find_checkmate
    @legal_moves.each do |pos, moves_arr|
      moves_arr.each do |end_move|
        dupe = @board.dup

        dupe[pos].move(end_move)

        opp_color = color == :white ? :black : :white
        return [pos, end_move] if dupe.check_mate?(opp_color)
      end
    end
    nil
  end
end
