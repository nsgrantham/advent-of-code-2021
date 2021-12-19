import Base: convert, parse

abstract type Packet end

struct LiteralValue <: Packet
    version::Int
    value::Int
end

struct Operator <: Packet
    version::Int
    action::Function
    subpackets::Vector{Packet}
end

convert(::Type{Int}, bits::BitVector) = foldl((x, y) -> (x << 1) | y, bits)

popfirstn!(collection, n) = convert(typeof(collection), [popfirst!(collection) for _ in 1:n])

function parse(::Type{BitVector}, str::String)
    bitify(n) = collect(bitstring(n))[5:8] .== '1'
    reduce(vcat, bitify.(parse.(UInt8, collect(str), base = 16)))
end

function decode!(::Type{Packet}, bits::BitVector)
    type_id = convert(Int, bits[4:6])
    decode!(type_id == 4 ? LiteralValue : Operator, bits)
end

function decode!(::Type{LiteralValue}, bits::BitVector)
    version = convert(Int, popfirstn!(bits, 3))
    popfirstn!(bits, 3)  # skip type id as it is always 4
    value = empty(bits)
    more_groups = true
    while more_groups
        more_groups = popfirst!(bits)
        append!(value, popfirstn!(bits, 4))
    end
    LiteralValue(version, convert(Int, value .== 1))
end

function decode!(::Type{Operator}, bits::BitVector)
    version = convert(Int, popfirstn!(bits, 3))
    type_id = convert(Int, popfirstn!(bits, 3))
    action = type_id < 4 ? (sum, prod, minimum, maximum)[type_id + 1] : (>, <, ==)[type_id - 4]
    length_type_id = convert(Int, popfirst!(bits))
    subpackets = Packet[]
    if length_type_id == 1
        n_subpackets = convert(Int, popfirstn!(bits, 11))
        for _ in 1:n_subpackets
            push!(subpackets, decode!(Packet, bits))
        end
    else
        n_bits = convert(Int, popfirstn!(bits, 15))
        n_remaining_bits = length(bits) - n_bits
        while length(bits) > n_remaining_bits
            push!(subpackets, decode!(Packet, bits))
        end
    end
    Operator(version, action, subpackets)
end

versions(packet::Operator) = append!([packet.version], versions.(packet.subpackets)...)

versions(packet::LiteralValue) = packet.version

function execute(packet::Operator)
    packet.action in (sum, prod, minimum, maximum) ? (
        packet.action(execute.(packet.subpackets))
    ) : (
        packet.action(execute.(packet.subpackets)...)
    )
end

execute(packet::LiteralValue) = packet.value

bits = parse(BitVector, readline("day16/transmission.txt"))
packet = decode!(Packet, bits)

p1 = sum(versions(packet))

@show p1

p2 = execute(packet)

@show p2
