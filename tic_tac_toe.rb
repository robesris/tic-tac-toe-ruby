require 'forwardable'

class Square
  BLANK = "_"
  attr_accessor :value

  def initialize(row, col, diagonals = [])
    @value = BLANK
    @lines = [row, col, diagonals].flatten
  end

  def taken?
    @value != BLANK
  end

  def take(player)
    @value = player
    update_line_winners
  end

  def draw
    print @value
  end

  private

  def update_line_winners
    # update the "winning" status and score for each row, col, and diagonal the square belongs to
    @lines.each do |line|
      line.update_winner(value)
    end
  end
end

class Line
  extend Forwardable

  attr_accessor :score

  UNWINNABLE = -1

  def_delegators :@squares, :[], :[]=, :<<, :size

  def initialize(num, game)
    @game = game
    @score = 0    # how many squares the player "winning" this Line has claimed   
    @winner = nil # who is "winning" this Line
    @num = num
    @squares = []
  end

  def update_winner(value)
    if @winner.nil? || @winner == value
      @winner = value
      @score += 1
      @game.win(value) if @score >= size # win the game if the current player has taken all the squares in this line
    else
      @winner = UNWINNABLE
      @game.increment_unwinnable_lines # tell the game this line is unwinnable
    end
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
  attr_accessor :rows, :cols, :diagonals, :winner

  PLAYER_X = "X"
  PLAYER_O = "O"
  STALEMATE = "STALEMATE"

  def initialize(width = 3)
    @winner = nil
    @max = width - 1
    @rows = []
    @cols = []
    @diagonals = [Line.new(0, self), Line.new(1, self)] # always exactly 2 diagonals for a square board
    @current_player = PLAYER_X
    @line_count = 2 * width + 2 # the total number of Lines (i.e. rows + cols + diagonals)
    @unwinnable_lines = 0 # when this number equals @line_count, we have a stalemate

    0.upto(@max) do |row_num|
      row = Line.new(row_num, self)
      @rows[row_num] = row
      
      0.upto(@max) do |col_num|
        unless col = @cols[col_num]
          col = Line.new(col_num, self)
          @cols[col_num] = col
        end

        square = Square.new(row, col)

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
      # check_for_game_over
      swap_players
      draw
    end
  end

  def win(value)
    @winner = value
  end

  def increment_unwinnable_lines
    @unwinnable_lines += 1
    @winner = STALEMATE if @unwinnable_lines >= @line_count
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
