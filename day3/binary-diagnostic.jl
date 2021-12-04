numbers = readlines("day3/numbers.txt")
numbers = permutedims(hcat(collect.(numbers)...))
numbers = parse.(Int, numbers)

function find_rates(numbers)
    γ_bits = sum(numbers, dims = 1) .> size(numbers, 1) / 2
    ε_bits = map(~, γ_bits)  # bitwise not
    γ = parse(Int, join(convert(Array{Int}, γ_bits)), base = 2)
    ε = parse(Int, join(convert(Array{Int}, ε_bits)), base = 2)
    γ, ε
end

γ, ε = find_rates(numbers)
p1 = γ * ε

@show p1

function find_rating(numbers, keep_bit)
    more_numbers = true
    bit_idx = 1
    while more_numbers
        bits = numbers[:, bit_idx]
        numbers = numbers[bits .== keep_bit(bits), :]
        more_numbers = size(numbers, 1) > 1
        bit_idx += 1
    end
    parse(Int, join(numbers), base = 2)
end

most_common_bit(bits) = sum(bits) >= length(bits) / 2 ? 1 : 0

least_common_bit(bits) = sum(bits) >= length(bits) / 2 ? 0 : 1

oxy = find_rating(numbers, most_common_bit)
co2 = find_rating(numbers, least_common_bit)
p2 = oxy * co2

@show p2
