depths = parse.(Int, readlines("day1/depths.txt"))

p1 = sum(diff(depths) .> 0)

@show p1

p2 = sum(diff([sum(depths[i:i+2]) for i in 1:length(depths)-2]) .> 0)

@show p2
