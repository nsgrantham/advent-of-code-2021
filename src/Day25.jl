module Day25

using AdventOfCode

struct SeaCucumberHerd
    east::Dict{Int, Vector{Int}}
    south::Dict{Int, Vector{Int}}
    xmax::Int
    ymax::Int
end

function moveeast!(herd::SeaCucumberHerd)
    n = 0
    for (x, ys) in deepcopy(herd.east)
        for (i, y) in enumerate(ys)
            ynew = mod1(y + 1, herd.ymax)
            ynew in ys && continue
            ynew in keys(herd.south) && x in herd.south[ynew] && continue
            herd.east[x][i] = ynew
            n += 1
        end
    end
    n
end

function movesouth!(herd::SeaCucumberHerd)
    n = 0
    for (y, xs) in deepcopy(herd.south)
        for (i, x) in enumerate(xs)
            xnew = mod1(x + 1, herd.xmax)
            xnew in xs && continue
            xnew in keys(herd.east) && y in herd.east[xnew] && continue
            herd.south[y][i] = xnew
            n += 1
        end
    end
    n
end

function step!(herd::SeaCucumberHerd)
    moveeast!(herd) + movesouth!(herd)
end

function Base.parse(::Type{SeaCucumberHerd}, lines::Vector{String})
    east = Dict{Int, Vector{Int}}()
    south = Dict{Int, Vector{Int}}()
    for (x, line) in enumerate(lines)
        for (y, char) in enumerate(collect(line))
            char == '>' && push!(get!(valtype(east), east, x), y)
            char == 'v' && push!(get!(valtype(south), south, y), x)
        end
    end
    SeaCucumberHerd(east, south, length(lines), length(lines[1]))
end

function solve(input = datapath("2021", "day25.txt"))
    herd = parse(SeaCucumberHerd, readlines(input))
    maximum(Iterators.takewhile(_ -> step!(herd) > 0, Iterators.countfrom(1))) + 1
end

end
