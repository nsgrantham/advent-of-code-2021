
function find_low_risk_path(chitons)
    cavern = CartesianIndices(chitons)
    moves = CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1)))
    start, finish = extrema(cavern)
    prev_position = Dict{CartesianIndex{2}, CartesianIndex{2}}()
    tentative_risk = fill(typemax(Int), size(chitons))
    tentative_risk[start] = 0
    queue = [(start, 0)]
    while !isempty(queue)
        position, risk = popat!(queue, last(findmin(last, queue)))
        if position == finish
            path = [finish]
            while first(path) != start
                pushfirst!(path, prev_position[first(path)])
            end
            return risk, path
        end
        if risk <= tentative_risk[position]
            tentative_risk[position] = risk
            for neighbor in [position + move for move in moves if position + move in cavern]
                neighbor_risk = risk + chitons[neighbor]
                if neighbor_risk < tentative_risk[neighbor]
                    tentative_risk[neighbor] = neighbor_risk
                    prev_position[neighbor] = position
                    push!(queue, (neighbor, neighbor_risk))
                end
            end
        end
    end
    nothing  # finish is not reachable
end

function expand_chitons(chitons)
    chitons = [
        chitons    chitons.+1 chitons.+2 chitons.+3 chitons.+4
        chitons.+1 chitons.+2 chitons.+3 chitons.+4 chitons.+5
        chitons.+2 chitons.+3 chitons.+4 chitons.+5 chitons.+6
        chitons.+3 chitons.+4 chitons.+5 chitons.+6 chitons.+7
        chitons.+4 chitons.+5 chitons.+6 chitons.+7 chitons.+8
    ]
    chitons .= mod1.(chitons, 9)
    chitons
end

chitons = collect.(readlines("day15/chitons.txt"))
chitons = parse.(Int, permutedims(hcat(chitons...)))

p1, _ = find_low_risk_path(chitons)

@show p1

p2, _ = find_low_risk_path(expand_chitons(chitons))

@show p2
