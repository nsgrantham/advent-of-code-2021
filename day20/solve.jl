mutable struct Image
    pixels::Dict{CartesianIndex{2}, Bool}
    infinite_pixel::Bool
    Image(pixels) = new(pixels, false)
end

function enhance!(image::Image, algo::BitVector)
    moves = CartesianIndex.((
        (-1, -1), (-1, 0), (-1, 1),
        ( 0, -1), ( 0, 0), ( 0, 1),
        ( 1, -1), ( 1, 0), ( 1, 1)
    ))
    min_index = minimum(keys(image.pixels)) + first(moves)
    max_index = maximum(keys(image.pixels)) + last(moves)
    enhanced_pixels = empty(image.pixels)
    for index in min_index:max_index
        bits = [get(image.pixels, index + move, image.infinite_pixel) for move in moves]
        enhanced_pixels[index] = algo[convert(Int, bits) + 1]
    end
    image.pixels = enhanced_pixels
    image.infinite_pixel = image.infinite_pixel ? last(algo) : first(algo)
    image
end

Base.convert(::Type{Int}, bits::Vector{Bool}) = foldl((x, y) -> (x << 1) | y, bits)

function Base.parse(::Type{Image}, lines::Vector{String})
    bits = permutedims(hcat(collect.(lines)...)) .== '#'
    pixels = Dict(zip(CartesianIndices(bits), bits))
    Image(pixels)
end

function part1(input)
    algo = collect(readline(input)) .== '#'
    image = parse(Image, readlines(input)[3:end])
    for _ in 1:2
        enhance!(image, algo)
    end
    sum(values(image.pixels))
end

function part2(input)
    algo = collect(readline(input)) .== '#'
    image = parse(Image, readlines(input)[3:end])
    for _ in 1:50
        enhance!(image, algo)
    end
    sum(values(image.pixels))
end

@show part1("day20/image.txt")

@show part2("day20/image.txt")
