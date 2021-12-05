function draw_line(vent)
    x1, y1, x2, y2 = vent
    xs = x1 == x2 ? fill(x1, abs(y2 - y1) + 1) : x1:sign(x2 - x1):x2
    ys = y1 == y2 ? fill(y1, abs(x2 - x1) + 1) : y1:sign(y2 - y1):y2
    [zip(xs, ys)...]
end

function count_overlaps(lines)
    overlaps = Dict{Tuple{Int, Int}, Int}()
    points = reduce(vcat, lines)
    for point in points
        overlaps[point] = get(overlaps, point, 0) + 1
    end
    overlaps
end

vents = [
    parse.(Int, split(replace(vent, " -> " => ','), ','))
    for vent in readlines("day5/vents.txt")
]

is_hv(vent) = (vent[1] == vent[3]) | (vent[2] == vent[4])

hv_vents = filter(is_hv, vents)
hv_lines = draw_line.(hv_vents)
hv_overlaps = count_overlaps(hv_lines)

p1 = sum(values(hv_overlaps) .>= 2)

@show p1

all_lines = draw_line.(vents)
all_overlaps = count_overlaps(all_lines)

p2 = sum(values(all_overlaps) .>= 2)

@show p2
