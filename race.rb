require "./ecosystem.rb"

#(obediance(head), speed(RL), footing(FL), stamina(RL), build(FL)) -> 1 bad to 100 good
#Same blood type for Head+FL+RL = Obediance boost

zhorses = {
  0=>Zhorse.new(65, 70, 40, 80, 40),
  1=>Zhorse.new(80, 40, 80, 40, 80),
  2=>Zhorse.new(40, 80, 40, 80, 40),
  3=>Zhorse.new(40, 40, 80, 40, 80),
  4=>Zhorse.new(50, 50, 50, 50, 50),
  5=>Zhorse.new(50, 30, 90, 50, 50),
  6=>Zhorse.new(70, 70, 60, 80, 40),
  7=>Zhorse.new(80, 40, 80, 40, 80),
  8=>Zhorse.new(20, 80, 40, 80, 40),
  9=>Zhorse.new(20, 30, 80, 40, 80),
  10=>Zhorse.new(40, 90, 50, 50, 50)
}

#(sprints points, curves points, slopes points, rounds) 
#*slopes can be seen as difficulty level (the more the hardest)
#(zhorses, zhorse_id, top_n) -> testing chances

 racetrial = Race.new(10, 5, 2, 10) #classic race
 racetrial.winner(zhorses)
# racetrial.winner_testing_horse(zhorses, 8, 3)

#racetrial = Race.new(5, 10, 200, 10) #race focus on slopes
# racetrial.winner(zhorses)
# racetrial.winner_testing_horse(zhorses, 1, 3)

# racetrial = Race.new(500, 10, 2, 10) #race focus on sprints
# racetrial.winner(zhorses)
# racetrial.winner_testing_horse(zhorses, 7, 3)

# racetrial = Race.new(5, 100, 2, 10) #race focus on curves
# racetrial.winner(zhorses)
# racetrial.winner_testing_horse(zhorses, 1, 3)