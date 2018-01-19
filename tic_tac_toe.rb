class Square
  BLANK = "_"
  attr_accessor :value

  def initialize
    @value = BLANK
  end

  def draw
    print @value
  end
end

class Line
  extend Forwardable

  def_delegators :@squares, :[], :[]=, :<<

  def initialize(num)
    @num = num
    @squares = []
  end

  def draw
    @squares.each { |square| square.draw }
    print "\n"
  end

end

class Game
  attr_accessor :rows, :cols, :diagonals

  def initialize(width = 3)
    @max = width - 1
    @rows = []
    @cols = []
    @diagonals = [Line.new(0), Line.new(1)] # always exactly 2 diagonals for a square board

    0.upto(@max) do |row_num|
      row = Line.new(row_num)
      @rows[row_num] = row
      
      0.upto(@max) do |col_num|
        unless col = @cols[col_num]
          col = Line.new(col_num)
          @cols[col_num] = col
        end

        square = Square.new

        @rows[row_num] << square
        @cols[col_num] << square

        if col_num == row_num
          @diagonals.first[col_num] = square
        elsif col_num + row_num == @max
          @diagonals.last[col_num] = square
        end
      end
    end
  end

  def draw
    @rows.each{ |row| row.draw }
    print "\n"
  end

end
