# tic-tac-toe-ruby

# Run the (rudimentary) tests:

```
irb
require './test.rb'
```

You should see all tests pass.

# Play around with it

```
irb
require './tic_tac_toe.rb'
g = TicTacToe::Game.new;nil # the nil suppresses the output of the return value of Game.new
g.play 0, 1
g.winner
 => nil
```

With a bigger board:

```
g = TicTacToe::Game.new(5)
g.play 3, 4
```

etc...

# How it Works

This key data structure of this tic-tac-toe program is the Line class. A Line represents a row, column, or diagonal, and each Square on the board can be accessed through any of the Lines which contain it.

Each Line is aware of the following:
- If it is an "unwinnable" Line (i.e. there are both X's and O's in it, so neither player can win along it)
- If there is only one player's marks in it, how many there are

Since a Line (and therefore the Game) is won when the number of X's or O's in a Line is equal to the size of the line, this allows us to check for a winner or a stalemate in O(1) time, regardless of the size of the board.  Bascially:

1. Make a move
2. For each row, column, and diagonal the square is present in (maximum of 4, regardless of board size):
  - Check if the line is unwinnable (i.e. marks from both players are present)
  - If it is unwinnable, increment the count of unwinnable Lines.
  - If not, increment the score for this Line for the current player and check if the score equals the size of the Line
  - If we have the target score, the Line and the Game is won.
3. If the Line was marked unwinnable, check if the count of Lines marked unwinnable is equal to the total number of lines. If so, the game ends in a Stalemate.
