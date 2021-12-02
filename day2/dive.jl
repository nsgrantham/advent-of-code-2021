commands = readlines("day2/commands.txt")

function dive(commands)
    h, d = (0, 0)
    for command in commands
        dir, x = split(command)
        x = parse(Int, x)
        if dir == "forward"
            h += x
        else
            d += dir == "down" ? x : -x
        end
    end
    return (h, d)
end

h, d = dive(commands)
p1 = h * d

@show p1

function dive2(commands)
    h, d, a = (0, 0, 0)
    for command in commands
        dir, x = split(command)
        x = parse(Int, x)
        if dir == "forward"
            h += x
            d += x * a
        else
            a += dir == "down" ? x : -x
        end
    end
    return (h, d, a)
end

h, d, _ = dive2(commands)
p2 = h * d

@show p2
