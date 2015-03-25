# encoding: utf-8
class SlidingPiece < Piece
  # Bishops, Queens, and Rooks!

  def initialize(board, color, pos, symbol, *directions) # :rows, :cols, :diags
    super(board, color, pos, symbol)
    @deltas = []
    directions.each{ |dir| @deltas << dir }
  end

  def pos_moves
    possible_moves = []

    create_deltas.each_value do | delta |
      delta.each do | one_direction |
        one_direction.each do |tile|
          if board[tile].nil?
            possible_moves << tile
          elsif board[tile].color != color
            possible_moves << tile
            break
          else
            break
          end
        end
      end
    end

    possible_moves
  end

  def legal_moves
    pos_moves.select {|pos_pos| !move_into_check?(pos_pos) }
  end

  def create_deltas
    direction_hash = {} #Hash.new{|h,k| h[k] = []}

    direction_hash[:rows] = get_row if @deltas.include?(:rows)
    direction_hash[:cols] = get_col if @deltas.include?(:cols)
    direction_hash[:diags] = get_diags if @deltas.include?(:diags)

    direction_hash
  end

  def get_row
    row = Array.new(2) {[]}
    @board.rows[@pos[0]].each_index do |col|
      if col < @pos[1]
        row[0] << [@pos[0], col]
      elsif col > @pos[1]
        row[1] << [@pos[0], col]
      end
    end

    # puts row[0] in order of closness
    row[0].reverse!

    row
  end

  def get_col
    col = Array.new(2) {[]}
    @board.rows.each_index do |row|
      if row < @pos[0]
        col[0] << [row, pos[1]]
      elsif row > @pos[0]
        col[1] << [row, pos[1]]
      end
    end

    # puts col[0] in order of closeness
    col[0].reverse!

    col
  end

  def get_diags
    diag = Array.new(4) {[]}

    (1..7).each do |num|
      diag[0] << [pos[0] + num, pos[1] + num]
      diag[1] << [pos[0] - num, pos[1] - num]
      diag[2] << [pos[0] - num, pos[1] + num]
      diag[3] << [pos[0] + num, pos[1] - num]
    end

    # filter out of bounds
    diag[0].select!{|el| el[0].between?(0,7) && el[1].between?(0,7)}
    diag[1].select!{|el| el[0].between?(0,7) && el[1].between?(0,7)}
    diag[2].select!{|el| el[0].between?(0,7) && el[1].between?(0,7)}
    diag[3].select!{|el| el[0].between?(0,7) && el[1].between?(0,7)}

    diag
  end

  def dup(new_board)
    dup_piece = self.class.new(new_board, color, pos, symbol, *@deltas)
  end

end
