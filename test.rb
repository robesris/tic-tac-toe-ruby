require './tic_tac_toe.rb'

puts "X Wins on Horizontal"
g = TicTacToe::Game.new
g.play 0, 0
g.play 2, 2
g.play 0, 1
g.play 2, 0
g.play 0, 2
if g.winner == "X"
  puts "PASS"
else
  puts "FAILURE: Expected X to Win but game result was #{g.winner}"
end

puts "\n\n"
puts "O Wins on Diagonal"
g = TicTacToe::Game.new
g.play 1, 0
g.play 0, 2
g.play 2, 2
g.play 2, 0
g.play 0, 1
g.play 1, 1
if g.winner == "O"
  puts "PASS"
else
  puts "FAILURE: Expected O to Win but game result was #{g.winner}"
end

puts "\n\n"
puts "Game finds a draw before all squares are filled"
g = TicTacToe::Game.new
g.play 0, 1
g.play 0, 0
g.play 0, 2
g.play 1, 1
g.play 1, 0
g.play 1, 2
g.play 2, 2
g.play 2, 1
if g.winner == "STALEMATE"
  puts "PASS"
else
  puts "FAILURE: Expected STALEMATE but game result was #{g.winner}"
end

# O X X
# X O O
# _ O X
