using LinearAlgebra: cross

mutable struct Scanner
    position::Union{Vector{Int}, Nothing}
    beacons::Vector{Vector{Int}}
    Scanner() = new(nothing, Vector{Int}[])
    Scanner(position, beacons) = new(position, beacons)
end

copy(scanner::Scanner) = Scanner(scanner.position, scanner.beacons)

islocated(scanner::Scanner) = !isnothing(scanner.position)

function locate!(scanners::Vector{Scanner})
    if !any(islocated.(scanners))
        scanners[1].position = [0, 0, 0]
    end
    located_scanners = filter(islocated, scanners)
    while length(located_scanners) < length(scanners)
        for located_scanner in located_scanners
            for scanner in scanners
                islocated(scanner) && continue
                orient!(located_scanner, scanner) && push!(located_scanners, scanner)
            end
        end
    end
end

function orient!(origin::Scanner, scanner::Scanner)
    # using LinearAlgebra: cross
    # basis = [
    #     [ 1,  0,  0],
    #     [ 0,  1,  0],
    #     [ 0,  0,  1],
    #     [-1,  0,  0],
    #     [ 0, -1,  0],
    #     [ 0,  0, -1]
    # ]
    # rotations = Matrix{Int}[]
    # for b1 in basis, b2 in basis
    #     b3 = cross(b1, b2)
    #     b3 == [0, 0, 0] && continue
    #     push!(rotations, hcat(b1, b2, b3))
    # end
    rotations = [
        [[ 1  0  0;  0  1  0;  0  0  1]]
        [[ 1  0  0;  0  0 -1;  0  1  0]]
        [[ 1  0  0;  0 -1  0;  0  0 -1]]
        [[ 1  0  0;  0  0  1;  0 -1  0]]
        [[ 0  1  0;  1  0  0;  0  0 -1]]
        [[ 0  0  1;  1  0  0;  0  1  0]]
        [[ 0 -1  0;  1  0  0;  0  0  1]]
        [[ 0  0 -1;  1  0  0;  0 -1  0]]
        [[ 0  1  0;  0  0  1;  1  0  0]]
        [[ 0  0 -1;  0  1  0;  1  0  0]]
        [[ 0 -1  0;  0  0 -1;  1  0  0]]
        [[ 0  0  1;  0 -1  0;  1  0  0]]
        [[-1  0  0;  0  1  0;  0  0 -1]]
        [[-1  0  0;  0  0  1;  0  1  0]]
        [[-1  0  0;  0 -1  0;  0  0  1]]
        [[-1  0  0;  0  0 -1;  0 -1  0]]
        [[ 0  1  0; -1  0  0;  0  0  1]]
        [[ 0  0 -1; -1  0  0;  0  1  0]]
        [[ 0 -1  0; -1  0  0;  0  0 -1]]
        [[ 0  0  1; -1  0  0;  0 -1  0]]
        [[ 0  1  0;  0  0 -1; -1  0  0]]
        [[ 0  0  1;  0  1  0; -1  0  0]]
        [[ 0 -1  0;  0  0  1; -1  0  0]]
        [[ 0  0 -1;  0 -1  0; -1  0  0]]
    ]
    for rotation in rotations
        rotated_scanner = rotate(scanner, rotation)
        position = findposition(origin, rotated_scanner)
        if !isnothing(position)
            scanner.position = position
            scanner.beacons = [position + beacon for beacon in rotated_scanner.beacons]
            return true
        end
    end
    false
end

rotate(scanner::Scanner, rotation::Matrix{Int}) = rotate!(copy(scanner), rotation)

function rotate!(scanner::Scanner, rotation::Matrix{Int})
    scanner.beacons = [rotation * beacon for beacon in scanner.beacons]
    scanner
end

function findposition(origin::Scanner, scanner::Scanner)
    overlaps = Dict{Vector{Int}, Int}()
    for origin_beacon in origin.beacons
        for scanner_beacon in scanner.beacons
            position = origin_beacon - scanner_beacon
            overlaps[position] = get(overlaps, position, 0) + 1
        end
    end
    max_overlaps, position = findmax(overlaps)
    max_overlaps >= 12 && return position
    nothing
end

function Base.parse(::Type{Vector{Scanner}}, lines::Vector{String})
    scanners = Scanner[]
    for line in lines
        if occursin("scanner", line)
            push!(scanners, Scanner())
            continue
        end
        isempty(line) && continue
        scanner = last(scanners)
        push!(scanner.beacons, parse.(Int, split(line, ",")))
    end
    scanners
end

function beacons(scanners::Vector{Scanner})
    beacon_set = Set{Vector{Int}}()
    for scanner in scanners
        for beacon in scanner.beacons
            push!(beacon_set, beacon)
        end
    end
    beacon_set
end

scanners = parse(Vector{Scanner}, readlines("day19/scanners.txt"))

locate!(scanners)

p1 = length(beacons(scanners))

@show p1

p2 = maximum(sum(abs.(s1.position - s2.position)) for s1 in scanners for s2 in scanners)

@show p2
