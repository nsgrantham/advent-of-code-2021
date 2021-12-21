struct SnailfishNumber
    triplets::Vector{Tuple{Int, Int, Int}}  # value, depth, weight
end

SnailfishNumber(str::String) = parse(SnailfishNumber, str)

function Base.parse(::Type{SnailfishNumber}, str::String)
    elements = eval(Meta.parse(str))
    triplets = tripletize!(Tuple{Int, Int, Int}[], elements, 0, 1)
    SnailfishNumber(triplets)
end

function tripletize!(triplets, elements, depth, weight)
    left = (elements[1], depth + 1, weight * 3)
    right = (elements[2], depth + 1, weight * 2)
    first(left) isa Int ? push!(triplets, left) : tripletize!(triplets, left...)
    first(right) isa Int ? push!(triplets, right) : tripletize!(triplets, right...)
    triplets
end

function Base.:+(x::SnailfishNumber, y::SnailfishNumber)
    triplets = vcat(
        [(value, depth + 1, weight * 3) for (value, depth, weight) in x.triplets],
        [(value, depth + 1, weight * 2) for (value, depth, weight) in y.triplets],
    )
    reduce!(SnailfishNumber(triplets))
end

function explode!(x::SnailfishNumber)
    for i in 1:length(x.triplets) - 1
        lvalue, ldepth, lweight = x.triplets[i]
        rvalue, rdepth, rweight = x.triplets[i + 1]
        is_exploding_pair = ldepth == rdepth == 5 && lweight > rweight
        if is_exploding_pair
            i > 1 && splice!(x.triplets, i - 1, [x.triplets[i - 1] .+ (lvalue, 0, 0)])
            i < length(x.triplets) - 1 && splice!(x.triplets, i + 2, [x.triplets[i + 2] .+ (rvalue, 0, 0)])
            deleteat!(x.triplets, i + 1)
            deleteat!(x.triplets, i)
            insert!(x.triplets, i, (0, ldepth - 1, div(lweight, 3)))
            return true
        end
    end
    false
end

function split!(x::SnailfishNumber)
    for i in 1:length(x.triplets)
        value, depth, weight = x.triplets[i]
        if value > 9
            deleteat!(x.triplets, i)
            insert!(x.triplets, i, (ceil(Int, value / 2), depth + 1, weight * 2))
            insert!(x.triplets, i, (floor(Int, value / 2), depth + 1, weight * 3))
            return true
        end
    end
    false
end

function reduce!(x::SnailfishNumber)
    while true
        explode!(x) && continue
        split!(x) && continue
        break
    end
    x
end

magnitude(x::SnailfishNumber) = sum(first.(x.triplets) .* last.(x.triplets))

numbers = SnailfishNumber.(readlines("day18/numbers.txt"))

p1 = magnitude(sum(numbers))

@show p1

p2 = maximum(magnitude.(x + y for x in numbers for y in numbers if x != y))

@show p2
