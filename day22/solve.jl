struct Cuboid
    x::UnitRange
    y::UnitRange
    z::UnitRange
end

struct RebootStep
    on::Bool
    cuboid::Cuboid
end

mutable struct Reactor
    on_cuboids::Vector{Cuboid}
    Reactor() = new(Cuboid[])
end

function Base.in(a::UnitRange, b::UnitRange)
    amin, amax = extrema(a)
    bmin, bmax = extrema(b)
    bmin <= amin <= bmax && bmin <= amax <= bmax
end

function Base.in(a::Cuboid, b::Cuboid)
    a.x in b.x && a.y in b.y && a.z in b.z
end

function Base.isdisjoint(a::Cuboid, b::Cuboid)
    isdisjoint(a.x, b.x) || isdisjoint(a.y, b.y) || isdisjoint(a.z, b.z)
end

function Base.split(a::UnitRange, b::UnitRange)
    (a in b || isdisjoint(a, b)) && return [a]
    amin, amax = extrema(a)
    bmin, bmax = extrema(b)
    amin < bmin && bmax < amax && return [amin:bmin-1, b, bmax+1:amax]
    amin < bmin && return [amin:bmin-1, bmin:amax]
    [amin:bmax, bmax+1:amax]
end

function Base.split(a::Cuboid, b::Cuboid)
    (a in b || isdisjoint(a, b)) && return [a]
    xs = split(a.x, b.x)
    ys = split(a.y, b.y)
    zs = split(a.z, b.z)
    [Cuboid(x, y, z) for (x, y, z) in Iterators.product(xs, ys, zs)]
end

function volume(a::Cuboid)
    length(a.x) * length(a.y) * length(a.z)
end

function reboot!(reactor::Reactor, step::RebootStep)
    step.on ? turnon!(reactor, step.cuboid) : turnoff!(reactor, step.cuboid)
end

function turnon!(reactor::Reactor, on_cuboid::Cuboid)
    reactor.on_cuboids = turnon(reactor.on_cuboids, on_cuboid)
end

function turnoff!(reactor::Reactor, off_cuboid::Cuboid)
    reactor.on_cuboids = turnoff(reactor.on_cuboids, off_cuboid)
end

function turnon(on_cuboids::Vector{Cuboid}, on_cuboid::Cuboid)
    push!(turnoff(on_cuboids, on_cuboid), on_cuboid)
end

function turnoff(on_cuboids::Vector{Cuboid}, off_cuboid::Cuboid)
    new_on_cuboids = empty(on_cuboids)
    for on_cuboid in on_cuboids
        if isdisjoint(on_cuboid, off_cuboid)
            push!(new_on_cuboids, on_cuboid)
            continue
        else
            split_cuboids = vec(split(on_cuboid, off_cuboid))
            for split_cuboid in split_cuboids
                if isdisjoint(split_cuboid, off_cuboid)
                    push!(new_on_cuboids, split_cuboid)
                end
            end
        end
    end
    new_on_cuboids
end

function Base.parse(::Type{RebootStep}, str::String)
    strs = split(replace(str, " x=" => ",", "y=" => "", "z=" => "", ".." => ","), ",")
    on = popfirst!(strs) == "on"
    xmin, xmax, ymin, ymax, zmin, zmax = parse.(Int, strs)
    RebootStep(on, Cuboid(xmin:xmax, ymin:ymax, zmin:zmax))
end

function isinit(step::RebootStep)
    step.cuboid in Cuboid(-50:50, -50:50, -50:50)
end

function part1(input)
    steps = parse.(RebootStep, eachline(input))
    init_steps = filter(isinit, steps)
    reactor = Reactor()
    for init_step in init_steps
        reboot!(reactor, init_step)
    end
    sum(volume.(reactor.on_cuboids))
end

function part2(input)
    steps = parse.(RebootStep, eachline(input))
    reactor = Reactor()
    for step in steps
        reboot!(reactor, step)
    end
    sum(volume.(reactor.on_cuboids))
end

@show part1("day22/steps.txt")
@show part2("day22/steps.txt")
