require_relative './square.rb'
require_relative './line.rb'

module TicTacToe
  class Game
    attr_accessor :rows, :cols, :diagonals, :winner, :unwinnable_lines, :line_count

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

          diags = []
          diags << @diagonals.first if row_num == col_num
          diags << @diagonals.last if row_num + col_num == @max
          square = Square.new(row, col, diags)

          @rows[row_num] << square
          @cols[col_num] << square
          diags.each do |diag|
            diag << square
          end

        end
      end
    end

    def draw
      @rows.each{ |row| row.draw }
      print "\n"

      case
      when @winner == STALEMATE
        puts "The game is a draw!"
      when [PLAYER_X, PLAYER_O].include?(@winner)
        puts "Player #{@winner} wins!"
      end
    end

    def play(row_num, col_num)
      square = square_at(row_num, col_num)

      case
      when square.taken?
        puts "That square is occupied!"
      when !@winner
        square.take(@current_player)
        swap_players
      end

      draw
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
end
