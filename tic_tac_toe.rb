require 'forwardable'

class Square
  BLANK = "_"
  attr_accessor :value

  def initialize
    @value = BLANK
  end

  def taken?
    @value != BLANK
  end

  def take(player)
    @value = player
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
    @squares.each do |square|
      square.draw
      print " "
    end
    print "\n"
  end

end

class Game
  attr_accessor :rows, :cols, :diagonals

  PLAYER_X = "X"
  PLAYER_O = "O"

  def initialize(width = 3)
    @max = width - 1
    @rows = []
    @cols = []
    @diagonals = [Line.new(0), Line.new(1)] # always exactly 2 diagonals for a square board
    @current_player = PLAYER_X

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

  def play(row_num, col_num)
    square = square_at(row_num, col_num)

    if square.taken?
      puts "That square is occupied!"
    else
      square.take(@current_player)
      #check_for_game_over
      swap_players
      draw
    end
  end

  private

  def square_at(row_num, col_num)
    @rows[row_num][col_num]
  end

  def swap_players
    if @current_player == PLAYER_X
      @current_player = PLAYER_O
    else
      @current_player = PLAYER_X
    end
  end

end
