function spelunk(caves; revisit_small_cave = false)
    future_caves = Dict{String, Vector{String}}()
    for (cave1, cave2) in caves
        cave2 != "start" && push!(get!(valtype(future_caves), future_caves, cave1), cave2)
        cave1 != "start" && push!(get!(valtype(future_caves), future_caves, cave2), cave1)
    end
    delete!(future_caves, "end")
    n_paths = 0
    states = [(present_cave = "start", past_caves = String[], small_cave_revisited = false)]
    while !isempty(states)
        present_cave, past_caves, small_cave_revisited = pop!(states)
        if present_cave == "end"
            n_paths += 1
            continue
        end
        for future_cave in future_caves[present_cave]
            is_small_cave_revisit = is_small(future_cave) && future_cave in past_caves
            small_cave_revisit_allowed = revisit_small_cave && !small_cave_revisited
            if is_small_cave_revisit && !small_cave_revisit_allowed
                continue
            end
            state = (
                present_cave = future_cave,
                past_caves = push!(copy(past_caves), present_cave),
                small_cave_revisited = small_cave_revisited || is_small_cave_revisit
            )
            push!(states, state)
        end
    end
    n_paths
end

function is_small(cave)
    all(islowercase, collect(cave))
end


caves = split.(readlines("day12/caves.txt"), "-")

p1 = spelunk(caves)

@show p1

p2 = spelunk(caves, revisit_small_cave = true)

@show p2
