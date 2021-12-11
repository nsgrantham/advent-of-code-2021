function measure_energy(octos, steps; stop_on_all_flash = false)
    octos = pairs(copy(octos))
    neighbors = Dict(
        (index, filter(i -> i in keys(octos), find_neighbors(index)))
        for index in keys(octos)
    )
    flashes = 0
    for step in 1:steps
        for index in keys(octos)
            octos[index] += 1
        end
        while any(values(octos) .> 9)
            for (index, energy) in octos
                if energy > 9
                    flashes += 1
                    octos[index] = 0
                    for neighbor in neighbors[index]
                        if octos[neighbor] > 0
                            octos[neighbor] += 1
                        end
                    end
                end
            end
        end
        if stop_on_all_flash & all(values(octos) .== 0)
            return flashes, step
        end
    end
    flashes, steps
end

function find_neighbors(index)
    CartesianIndex.(
        Tuple(index) .+ move for move in [
            (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1)
        ]
    )
end

octos = collect.(readlines("day11/octos.txt"))
octos = parse.(Int, permutedims(hcat(octos...)))

p1, _ = measure_energy(octos, 100)

@show p1

_, p2 = measure_energy(octos, 1000, stop_on_all_flash = true)

@show p2
