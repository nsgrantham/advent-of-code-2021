struct Amphipod
    kind::Symbol
    position::Tuple{Int, Int}
    energy_used::Int
end

struct Burrow
    amphipods::Vector{Amphipod}
    spaces::Vector{Tuple{Int, Int}}
end

function cost(amphipod::Amphipod)
    amphipod.kind == :A && return 1
    amphipod.kind == :B && return 10
    amphipod.kind == :C && return 100
    amphipod.kind == :D && return 1000
end

function homecol(amphipod::Amphipod)
    amphipod.kind == :A && return 3
    amphipod.kind == :B && return 5
    amphipod.kind == :C && return 7
    amphipod.kind == :D && return 9
end

function ishome(amphipod::Amphipod, burrow::Burrow)
    row, col = amphipod.position
    (col != homecol(amphipod) || row == 1) && return false
    others = [get(burrow, (r, col)) for (r, _) in burrow.spaces if r > row]
    for other in others
        !isnothing(other) && other.kind != amphipod.kind && return false
    end
    true
end

function isvacant(burrow::Burrow, position::Tuple{Int, Int})
    position in burrow.spaces || return false
    for amphipod in burrow.amphipods
        amphipod.position == position && return false
    end
    true
end

function Base.get(burrow::Burrow, position::Tuple{Int, Int})
    for amphipod in burrow.amphipods
        amphipod.position == position && return amphipod
    end
    nothing
end


function Base.parse(::Type{Burrow}, lines::Vector{String})
    amphipods = Amphipod[]
    spaces = Tuple{Int, Int}[]
    for (row, line) in enumerate(lines[2:end-1])
        chars = collect(line[2:end])  # ignore first char so col begins counting at start of hallway
        for (col, char) in enumerate(chars)
            (char == '#' || char == ' ') && continue
            char == '.' && push!(spaces, (row, col))
            if char in ['A', 'B', 'C', 'D']
                push!(spaces, (row, col))
                push!(amphipods, Amphipod(Symbol(char), (row, col), 0))
            end
        end
    end
    Burrow(amphipods, spaces)
end

function isinhallway(amphipod::Amphipod)
    amphipod.position[1] == 1
end

function canenterhallway(amphipod::Amphipod, burrow::Burrow)
    isinhallway(amphipod) && return false
    row, col = amphipod.position
    all(isvacant(burrow, (r, col)) for (r, _) in burrow.spaces if r < row)
end

function canwalkhallway(amphipod::Amphipod, burrow::Burrow)
    _, col = amphipod.position
    home_col = homecol(amphipod)
    home_col == col && return true
    step = sign(home_col - col)
    all(isvacant(burrow, (1, c)) for c in col+step:step:home_col)
end

function canenterhome(amphipod::Amphipod, burrow::Burrow)
    others = [get(burrow, (r, homecol(amphipod))) for (r, _) in burrow.spaces if r > 1]
    all(isnothing(other) || other.kind == amphipod.kind for other in others)
end

function cangohome(amphipod::Amphipod, burrow::Burrow)
    (canenterhallway(amphipod, burrow) || isinhallway(amphipod)) &&
        canwalkhallway(amphipod, burrow) &&
        canenterhome(amphipod, burrow)
end

function moves(amphipod::Amphipod, burrow::Burrow)
    row, col = amphipod.position
    moves = Amphipod[]
    ishome(amphipod, burrow) && return moves
    if cangohome(amphipod, burrow)
        home_col = homecol(amphipod)
        home_row = sum(isvacant(burrow, (r, c)) for (r, c) in burrow.spaces if c == home_col)
        energy_used = amphipod.energy_used + cost(amphipod) * (row - 1 + abs(home_col - col) + home_row - 1)
        push!(moves, Amphipod(amphipod.kind, (home_row, home_col), energy_used))
    elseif canenterhallway(amphipod, burrow)
        energy_used = amphipod.energy_used + cost(amphipod) * (row - 1)
        left_energy_used = energy_used
        for left_col in col-1:-1:1
            !isvacant(burrow, (1, left_col)) && break
            left_energy_used += cost(amphipod)
            left_col in [3, 5, 7, 9] && continue
            push!(moves, Amphipod(amphipod.kind, (1, left_col), left_energy_used))
        end
        right_energy_used = energy_used
        for right_col in col+1:11
            !isvacant(burrow, (1, right_col)) && break
            right_energy_used += cost(amphipod)
            right_col in [3, 5, 7, 9] && continue
            push!(moves, Amphipod(amphipod.kind, (1, right_col), right_energy_used))
        end
    end
    moves
end

function totalenergy(burrow::Burrow)
    sum(amphipod.energy_used for amphipod in burrow.amphipods)
end

function isorganized(burrow::Burrow)
    all(ishome(amphipod, burrow) for amphipod in burrow.amphipods)
end

# function next(burrow::Burrow)
#     burrows_energy = Tuple{Burrow, Int}[]
#     energy = totalenergy(burrow)
#     for (i, amphipod) in enumerate(burrow.amphipods)
#         for move in moves(amphipod, burrow)
#             amphipods_copy = copy(burrow.amphipods)
#             splice!(amphipods_copy, i, [move])
#             next_burrow = Burrow(amphipods_copy, burrow.spaces)
#             push!(burrows_energy, (next_burrow, totalenergy(next_burrow) - energy))
#         end
#     end
#     burrows_energy
# end

# """
# Use Dijkstra's algorithm to find burrow organization with the lowest total energy
# """
# function organize(burrow::Burrow)
#     queue = [(burrow, 0)]
#     prev_burrow = Dict{Burrow, Burrow}()
#     tentative_energy = Dict{Burrow, Int}()
#     while !isempty(queue)
#         curr_burrow, curr_energy = popat!(queue, last(findmin(last, queue)))
#         if isorganized(curr_burrow)
#             burrow_states = [curr_burrow]
#             while first(burrow_states) != burrow
#                 pushfirst!(burrow_states, prev_burrow[first(burrow_states)])
#             end
#             return burrow_states, curr_energy
#         end
#         if curr_energy <= get!(tentative_energy, curr_burrow, typemax(Int))
#             tentative_energy[curr_burrow] = curr_energy
#             for (next_burrow, energy_used) in next(curr_burrow)
#                 next_energy = curr_energy + energy_used
#                 if next_energy < get!(tentative_energy, next_burrow, typemax(Int))
#                     prev_burrow[next_burrow] = curr_burrow
#                     push!(queue, (next_burrow, next_energy))
#                 end
#             end
#         end
#     end
#     nothing
# end

function moves(burrow::Burrow)
    burrows = Burrow[]
    for (i, amphipod) in enumerate(burrow.amphipods)
        for move in moves(amphipod, burrow)
            amphipods_copy = copy(burrow.amphipods)
            splice!(amphipods_copy, i, [move])
            push!(burrows, Burrow(amphipods_copy, burrow.spaces))
        end
    end
    burrows
end

function organize!(burrow::Burrow, energy::Vector{Int})
    burrows = moves(burrow)
    isempty(burrows) && return
    for b in burrows
        if isorganized(b)
            push!(energy, totalenergy(b))
        else
            organize!(b, energy)
        end
    end
end

lines = readlines("day23/burrow.txt")

burrow = parse(Burrow, lines)

energy = Int[]
@time organize!(burrow, energy)

p1 = minimum(energy)
@show p1

insert!(lines, 4, "  #D#C#B#A#")
insert!(lines, 5, "  #D#B#A#C#")

burrow = parse(Burrow, lines)

energy = Int[]
@time organize!(burrow, energy)

p2 = minimum(energy)
@show p2
