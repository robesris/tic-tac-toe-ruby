module TicTacToe
  class Square
    BLANK = "_"
    attr_accessor :value, :row, :col

    def initialize(row, col, diagonals = [])
      @value = BLANK
      @row = row
      @col = col
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
end
