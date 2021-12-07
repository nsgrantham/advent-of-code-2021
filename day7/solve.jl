crabs = parse.(Int, split(readline("day7/crabs.txt"), ','))

move_crabs(crabs, to) = sum(abs.(crabs .- to))

p1 = minimum(move_crabs(crabs, i) for i in 0:maximum(crabs))

@show p1

move_crabs2(crabs, to) = sum(sum(0:abs(crab - to)) for crab in crabs)

p2 = minimum(move_crabs2(crabs, i) for i in 0:maximum(crabs))

@show p2
