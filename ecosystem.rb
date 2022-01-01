class Zhorse
	attr_accessor :obediance, :speed, :footing, :stamina, :build, :speed_f, :footing_f, :build_f, :speed1, :speed2, :footing1, :footing2, :build1, :build2, :points
	def initialize(obediance, speed, footing, stamina, build)
		@obediance = obediance.to_f
		@speed = speed.to_f
		@footing = footing.to_f
		@stamina = stamina.to_f
		@build = build.to_f
		#Change according to other zhorses when running a race
		@speed_f = 0
		@footing_f = 0
		@build_f = 0
		#Total points at the end of a race
		@points = 0
		#Head obediance optimizes speed and footing skills
		@speed = @obediance + @speed
		@footing = @obediance + @footing
		
		#speed -> sprint
		#footing -> curve
		#build -> slope (race difficulty)
		#obediance -> boost speed and footing
		#stamina -> loss(speed+footing)
	end

	def win_factor(speed_f, footing_f, build_f)
		@speed_f = speed_f
		@footing_f = footing_f
		@build_f = build_f
	end

	def rng_distribution_points(speed1, speed2, footing1, footing2, build1, build2)
		@speed1 = speed1
		@speed2 = speed2
		@footing1 = footing1
		@footing2 = footing2
		@build1 = build1
		@build2 = build2
	end

	def race_points(points)
		@points = points
	end

end

class Race
	attr_accessor :sprint, :curve, :slope, :round
	def initialize(sprint, curve, slope, round)
		@sprint = sprint.to_f
		@curve = curve.to_f
		@slope = slope.to_f
		@round = round
	end

	def zhorse_chances(zhorses)
	#Compute chances of zhorse compare to all zhorses
		total_speed = zhorses.sum {|k,v| v.speed }.to_f
		total_footing = zhorses.sum {|k,v| v.footing }.to_f
		total_build = zhorses.sum {|k,v| v.build }.to_f
		i = 0
		while i < zhorses.count
			speed_f = zhorses[i].speed / total_speed
			footing_f = zhorses[i].footing / total_footing
			build_f = zhorses[i].build / total_build
			zhorses[i].win_factor(speed_f, footing_f, build_f)
			i+=1
		end
	end

	def rng_ranges(zhorses)
	#Establish RNG range distribution for speed, footing, build
		i=0
		while i < zhorses.count
			if i == 0
				zhorses[i].rng_distribution_points(0, zhorses[i].speed_f, 0, zhorses[i].footing_f, 0, zhorses[i].build_f)
			else
				prev_horse_count = i - 1
				prev_horse = zhorses[prev_horse_count]
				speed2 = zhorses[i].speed_f + prev_horse.speed2
				footing2 = zhorses[i].footing_f + prev_horse.footing2
				build2 = zhorses[i].build_f + prev_horse.build2
				zhorses[i].rng_distribution_points(prev_horse.speed2, speed2, prev_horse.footing2, footing2, prev_horse.build2, build2)
			end
		  i+=1
		end
	end

	def point_distribution(rng_arr_sprint, rng_arr_curve, rng_arr_slope, zhorses)
	#points attrinutions depending on race features
		#Points attribution for the sprints
		for i in rng_arr_sprint do
			count = 0
			while count < zhorses.count
				if i.between?(zhorses[count].speed1,zhorses[count].speed2)
					if zhorses[count].points > 0
						points = zhorses[count].points + self.sprint
						zhorses[count].race_points(points)
					else
						zhorses[count].race_points(self.sprint)
					end
				end
				count+=1
			end
		end
		#Points attribution for the curves
		for i in rng_arr_curve do
			count = 0
			while count < zhorses.count
				if i.between?(zhorses[count].footing1,zhorses[count].footing2)
					if zhorses[count].points > 0
						points = zhorses[count].points + self.curve
						zhorses[count].race_points(points)
					else
						zhorses[count].race_points(self.curve)
					end
				end
				count+=1
			end
		end
		#Points attribution for the slopes
		for i in rng_arr_slope do
			count = 0
			while count < zhorses.count
				if i.between?(zhorses[count].build1,zhorses[count].build2)
					if zhorses[count].points > 0
						points = zhorses[count].points + self.slope
						zhorses[count].race_points(points)
					else
						zhorses[count].race_points(self.slope)
					end
				end
				count+=1
			end
		end
	end

	def stamina_impact(zhorses)
		zhorses.each do |zh|
			#print "key: #{zh[0]} value: #{zh[1]}"
			zh[1].speed = (zh[1].stamina/100)*zh[1].speed
			zh[1].footing = (zh[1].stamina/100)*zh[1].footing
		end
	end

	def winner(zhorses)
		round = 0
		while round < self.round
			zhorse_chances(zhorses)
			rng_ranges(zhorses)
			rng_arr_sprint = zhorses.count.times.map { rand() }
			rng_arr_curve = zhorses.count.times.map { rand() }
			rng_arr_slope = zhorses.count.times.map { rand() }
			point_distribution(rng_arr_sprint, rng_arr_curve, rng_arr_slope, zhorses)
			#Stamina impact each round
			stamina_impact(zhorses)
			@output = zhorses.map {|k,v| [v.points, k]}.sort.reverse
			#print "Round #{round}: 1st:#{@output[0][1]}, 2nd:#{@output[1][1]} and 3rd:#{@output[2][1]}!!"
			round+=1
		end
		print @output.map {|k,v| v}.first(3)
		#print "Winner is zHorse #{@output[0][1]} ! followed by zHorse number #{@output[1][1]} and #{@output[2][1]}"	
	end

	def winner_testing_horse(zhorses, zhorse_id, top_n)
		winner(zhorses)
		race = 1
		#Testing untill how many races a given horse (include?) can be in the top 3 (first())
		while @output.map {|k,v| v}.first(top_n).include?(zhorse_id) == false
			winner(zhorses)
			race+=1
			print "Testing zhorse #{zhorse_id} for top #{top_n} chances, race: #{race}"
		end
		print "#{zhorse_id} included in top #{top_n} at race: #{race}"
	end
end