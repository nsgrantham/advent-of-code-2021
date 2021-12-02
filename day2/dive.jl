commands = readlines("day2/commands.txt")

function move(sub, dir, x)
    h, d = sub
    dir == "forward" && return (h = h + x, d)
    dir == "down" && return (h, d = d + x)
    dir == "up" && return (h, d = d - x)
end

function dive(commands)
    sub = (h = 0, d = 0)
    for command in commands
        dir, x = split(command, " ")
        x = parse(Int, x)
        sub = move(sub, dir, x)
    end
    return sub
end

sub = dive(commands)
p1 = sub.h * sub.d

@show p1

function move2(sub, dir, x)
    h, d, a = sub
    dir == "forward" && return (h = h + x, d = d + a * x, a)
    dir == "down" && return (h, d, a = a + x)
    dir == "up" && return (h, d, a = a - x)
end

function dive2(commands)
    sub = (h = 0, d = 0, a = 0)
    for command in commands
        dir, x = split(command, " ")
        x = parse(Int, x)
        sub = move2(sub, dir, x)
    end
    return sub
end

sub = dive2(commands)
p2 = sub.h * sub.d

@show p2
