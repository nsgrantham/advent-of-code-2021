fish = parse.(Int, split(readline("day6/fish.txt"), ','))

function forecast_fish(init, days)
    curr = merge(
        Dict((i, 0) for i in 0:8),
        Dict((i, count(==(i), init)) for i in unique(init))
    )
    for _ in 1:days
        prev = copy(curr)
        for i in 8:-1:1
            curr[i - 1] = prev[i]
        end
        curr[6] += prev[0]
        curr[8] = prev[0]
    end
    curr
end

p1 = sum(values(forecast_fish(fish, 80)))

@show p1

p2 = sum(values(forecast_fish(fish, 256)))

@show p2
