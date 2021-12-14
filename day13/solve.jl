using UnicodePlots: heatmap

function read_dots_and_folds(file)
    dots = Tuple{Int, Int}[]
    folds = Tuple{String, Int}[]
    for line in eachline(file)
        isempty(line) && continue
        if startswith(line, "fold")
            axis, at = split(replace(line, "fold along " => ""), "=")
            push!(folds, (axis, parse(Int, at)))
        else
            push!(dots, Tuple(parse.(Int, split(line, ","))))
        end
    end
    dots, folds
end

fold_x!(dots, x) = unique!(map!(dot -> (mirror(dot[1], x), dot[2]), dots, dots))

fold_y!(dots, y) = unique!(map!(dot -> (dot[1], mirror(dot[2], y)), dots, dots))

mirror(a, b) = a < b ? a : 2b - a

function fold!(dots, axis, at)
    axis == "x" && fold_x!(dots, at)
    axis == "y" && fold_y!(dots, at)
end

function plot(dots)
    x_max = maximum(x for x in first.(dots))
    y_max = maximum(y for y in last.(dots))
    paper = falses(y_max + 1, x_max + 1)
    for (x, y) in dots
        paper[y_max - y + 1, x + 1] = true
    end
    heatmap(paper)
end

dots, folds = read_dots_and_folds("day13/dots.txt")

first_fold = popfirst!(folds)
fold!(dots, first_fold...)
p1 = length(dots)

@show p1

for fold in folds
    fold!(dots, fold...)
end

plot(dots)
p2 = "PFKLKCFP"

@show p2
