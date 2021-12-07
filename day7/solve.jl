crabs = parse.(Int, split(readline("day7/crabs.txt"), ','))

function move_crabs(crabs, to)
    sum(abs.(crabs .- to))
end

p1 = min([move_crabs(crabs, i) for i in 0:max(crabs...)]...)

@show p1

function move_crabs2(crabs, to)
    sum(sum(0:abs(crab - to)) for crab in crabs)
end

p2 = min([move_crabs2(crabs, i) for i in 0:max(crabs...)]...)

@show p2
