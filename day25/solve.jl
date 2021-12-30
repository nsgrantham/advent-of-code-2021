struct SeaCucumberHerd
    eastward::Dict{Int, Vector{Int}}
    southward::Dict{Int, Vector{Int}}
    xmax::Int
    ymax::Int
end

function moveeast!(herd::SeaCucumberHerd)
    n = 0
    for (x, ys) in deepcopy(herd.eastward)
        for (i, y) in enumerate(ys)
            ynew = mod1(y + 1, herd.ymax)
            ynew in ys && continue
            ynew in keys(herd.southward) && x in herd.southward[ynew] && continue
            herd.eastward[x][i] = ynew
            n += 1
        end
    end
    n
end

function movesouth!(herd::SeaCucumberHerd)
    n = 0
    for (y, xs) in deepcopy(herd.southward)
        for (i, x) in enumerate(xs)
            xnew = mod1(x + 1, herd.xmax)
            xnew in xs && continue
            xnew in keys(herd.eastward) && y in herd.eastward[xnew] && continue
            herd.southward[y][i] = xnew
            n += 1
        end
    end
    n
end

function step!(herd::SeaCucumberHerd)
    moveeast!(herd) + movesouth!(herd)
end

function Base.parse(::Type{SeaCucumberHerd}, lines::Vector{String})
    eastward = Dict{Int, Vector{Int}}()
    southward = Dict{Int, Vector{Int}}()
    for (x, line) in enumerate(lines)
        for (y, char) in enumerate(collect(line))
            char == '>' && push!(get!(valtype(eastward), eastward, x), y)
            char == 'v' && push!(get!(valtype(southward), southward, y), x)
        end
    end
    SeaCucumberHerd(eastward, southward, length(lines), length(lines[1]))
end

herd = parse(SeaCucumberHerd, readlines("day25/cucumbers.txt"))

@time p1 = maximum(Iterators.takewhile(_ -> step!(herd) > 0, Iterators.countfrom(1))) + 1

@show p1
