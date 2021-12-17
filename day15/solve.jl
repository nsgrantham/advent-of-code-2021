
function find_lowest_total_risk(risks)
    cave = CartesianIndices(risks)
    moves = CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1)))
    start, finish = extrema(cave)
    total_risk = fill(typemax(Int), size(risks))
    total_risk[start] = 0
    heap = [(start, 0)]
    while !isempty(heap)
        position, risk = popat!(heap, last(findmin([last(h) for h in heap])))
        position == finish && return risk
        total_risk[position] < risk && continue
        total_risk[position] = risk
        for neighbor in [position + move for move in moves if position + move in cave]
            neighbor_risk = risk + risks[neighbor]
            if neighbor_risk < total_risk[neighbor]
                total_risk[neighbor] = neighbor_risk
                push!(heap, (neighbor, neighbor_risk))
            end
        end
    end
    nothing  # finish is not reachable
end

function expand_cave(risks)
    risks = [
        risks    risks.+1 risks.+2 risks.+3 risks.+4
        risks.+1 risks.+2 risks.+3 risks.+4 risks.+5
        risks.+2 risks.+3 risks.+4 risks.+5 risks.+6
        risks.+3 risks.+4 risks.+5 risks.+6 risks.+7
        risks.+4 risks.+5 risks.+6 risks.+7 risks.+8
    ]
    risks .= mod1.(risks, 9)
    risks
end

chitons = collect.(readlines("day15/chitons.txt"))
chitons = parse.(Int, permutedims(hcat(chitons...)))

p1 = find_lowest_total_risk(chitons)

@show p1

p2 = find_lowest_total_risk(expand_cave(chitons))

@show p2
