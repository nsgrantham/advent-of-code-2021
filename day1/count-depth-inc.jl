depths = parse.(Int, readlines("day1/depths.txt"))

p1 = sum(diff(depths) .> 0)

@show p1

p2 = sum(diff([sum(depths[i-2:i]) for i in 3:length(depths)]) .> 0)

@show p2
