require 'forwardable'

module TicTacToe
  class Line
    extend Forwardable

    attr_accessor :num, :score, :winner

    UNWINNABLE = -1

    def_delegators :@squares, :[], :[]=, :<<, :size, :each

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
      elsif @winner != UNWINNABLE
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
end
