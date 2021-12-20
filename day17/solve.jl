import Base: copy, in, parse

mutable struct Probe
    x_position::Int
    y_position::Int
    x_velocity::Int
    y_velocity::Int
end

struct Target
    x_min::Int
    x_max::Int
    y_min::Int
    y_max::Int
end

function step!(probe::Probe)
    probe.x_position += probe.x_velocity
    probe.y_position += probe.y_velocity
    probe.x_velocity -= sign(probe.x_velocity)
    probe.y_velocity -= 1
end

function in(probe::Probe, target::Target)
    target.x_min <= probe.x_position <= target.x_max &&
    target.y_min <= probe.y_position <= target.y_max
end

function copy(probe::Probe)
    Probe(probe.x_position, probe.y_position, probe.x_velocity, probe.y_velocity)
end

function parse(::Type{Target}, str::String)
    str = replace(str, "target area: x=" => "", " y=" => "", ".." => ",")
    bounds = parse.(Int, split(str, ","))
    Target(bounds...)
end

function willhit(probe::Probe, target::Target)
    probe = copy(probe)
    while true
        probe in target && return true
        probe.x_position > target.x_max && break
        probe.y_position < target.y_min && break
        step!(probe)
    end
    false
end

function part1(input)
    target = parse(Target, input)
    (target.y_min ^ 2 + target.y_min) ÷ 2
end

function part2(input)
    target = parse(Target, input)
    count(
        willhit(Probe(0, 0, x_velocity, y_velocity), target)
        for x_velocity in -target.x_max:target.x_max
        for y_velocity in target.y_min:-target.y_min
    )
end

p1 = part1(readline("day17/target.txt"))

@show p1

p2 = part2(readline("day17/target.txt"))

@show p2
