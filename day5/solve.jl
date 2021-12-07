function draw_line(vent)
    x1, y1, x2, y2 = vent
    xs = x1 == x2 ? fill(x1, abs(y2 - y1) + 1) : x1:sign(x2 - x1):x2
    ys = y1 == y2 ? fill(y1, abs(x2 - x1) + 1) : y1:sign(y2 - y1):y2
    [zip(xs, ys)...]
end

function overlap_lines(lines)
    overlaps = Dict{Tuple{Int, Int}, Int}()
    points = reduce(vcat, lines)
    for point in points
        overlaps[point] = get(overlaps, point, 0) + 1
    end
    overlaps
end

function is_hv(vent)
    x1, y1, x2, y2 = vent
    x1 == x2 || y1 == y2
end

vents = [
    parse.(Int, split(replace(vent, " -> " => ','), ','))
    for vent in readlines("day5/vents.txt")
]

hv_lines = draw_line.(filter(is_hv, vents))
hv_overlaps = overlap_lines(hv_lines)

p1 = sum(values(hv_overlaps) .>= 2)

@show p1

lines = draw_line.(vents)
overlaps = overlap_lines(lines)

p2 = sum(values(overlaps) .>= 2)

@show p2
