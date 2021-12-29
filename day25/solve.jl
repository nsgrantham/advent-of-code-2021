struct Cucumbers
    east::Dict{Int, Vector{Int}}
    south::Dict{Int, Vector{Int}}
    dims::Tuple{Int, Int}
end

function step!(cucumbers::Cucumbers)
    n = 0
    xmax, ymax = cucumbers.dims
    east = deepcopy(cucumbers.east)
    for (x, ys) in east
        for (i, y) in enumerate(ys)
            ynew = mod1(y + 1, ymax)
            ynew in ys && continue
            ynew in keys(cucumbers.south) && x in cucumbers.south[ynew] && continue
            cucumbers.east[x][i] = ynew
            n += 1
        end
    end
    south = deepcopy(cucumbers.south)
    for (y, xs) in south
        for (i, x) in enumerate(xs)
            xnew = mod1(x + 1, xmax)
            xnew in xs && continue
            xnew in keys(cucumbers.east) && y in cucumbers.east[xnew] && continue
            cucumbers.south[y][i] = xnew
            n += 1
        end
    end
    n
end

function Base.parse(::Type{Cucumbers}, lines::Vector{String})
    east = Dict{Int, Vector{Int}}()
    south = Dict{Int, Vector{Int}}()
    for (x, line) in enumerate(lines)
        for (y, char) in enumerate(collect(line))
            char == '>' && push!(get!(valtype(east), east, x), y)
            char == 'v' && push!(get!(valtype(south), south, y), x)
        end
    end
    Cucumbers(east, south, (length(lines), length(lines[1])))
end

cucumbers = parse(Cucumbers, readlines("day25/cucumbers.txt"))

p1 = maximum(Iterators.takewhile(_ -> step!(cucumbers) > 0, Iterators.countfrom(1))) + 1

@show p1
