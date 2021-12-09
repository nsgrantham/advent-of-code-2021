heightmap = collect.(readlines("day9/heightmap.txt"))
heightmap = parse.(Int, permutedims(hcat(heightmap...)))
heightmap = pairs(heightmap)

function find_neighbors(index)
    CartesianIndex.(Tuple(index) .+ dir for dir in [(-1, 0), (1, 0), (0, -1), (0, 1)])
end

function find_lows(heightmap)
    lows = []
    for (index, value) in heightmap
        neighbor_values = [get(heightmap, i, 9) for i in find_neighbors(index)]
        if all(value .< neighbor_values)
            push!(lows, index)
        end
    end
    lows
end

p1 = sum(heightmap[i] + 1 for i in find_lows(heightmap))

@show p1

function find_basins(heightmap)
    lows = find_lows(heightmap)
    basins = []
    for low in lows
        indices = Set([low])
        basin = empty(indices)
        while !isempty(indices)
            index = pop!(indices)
            neighbors = find_neighbors(index)
            filter!(i -> get(heightmap, i, 9) < 9 && !(i in basin), neighbors)
            union!(indices, neighbors)
            push!(basin, index)
        end
        push!(basins, basin)
    end
    basins
end

basins = find_basins(heightmap)
p2 = prod(sort(length.(basins), rev = true)[1:3])

@show p2
