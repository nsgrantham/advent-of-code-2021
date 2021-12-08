displays = split.(readlines("day8/displays.txt"), " | ")
displays = [map(split, display) for display in displays]

is_easy_digit(pattern) = length(pattern) in [2, 3, 4, 7]

p1 = sum(sum(is_easy_digit.(outputs)) for (_, outputs) in displays)

@show p1


charsort(string) = join(sort(collect(string)))

contains_pattern(p1, p2) = all(p in p1 for p in p2)

function find_superset(patterns, pattern)
    findfirst(p -> contains_pattern(p, pattern), patterns)
end

function find_subset(patterns, pattern)
    findfirst(p -> contains_pattern(pattern, p), patterns)
end

function decode_display(display)
    signals, outputs = display
    signals = [charsort(signal) for signal in signals]
    signals = sort(signals, by = length)

    pattern = Dict([
        (1, signals[1]),  # only signal of length 2
        (7, signals[2]),  # only signal of length 3
        (4, signals[3]),  # only signal of length 4
        (8, signals[10])  # only signal of length 7
    ])

    signals_5 = signals[4:6]  # three signals (2, 3, 5) of length 5
    signals_6 = signals[7:9]  # three signals (0, 6, 9) of length 6

    pattern[3] = popat!(signals_5, find_superset(signals_5, pattern[7]))
    pattern[9] = popat!(signals_6, find_superset(signals_6, pattern[4]))
    pattern[0] = popat!(signals_6, find_superset(signals_6, pattern[1]))
    pattern[5] = popat!(signals_5, find_subset(signals_5, pattern[9]))
    pattern[2] = pop!(signals_5)
    pattern[6] = pop!(signals_6)

    digit = Dict((v, k) for (k, v) in pattern)
    output_digits = [digit[charsort(output)] for output in outputs]
    parse(Int, join(output_digits))
end

p2 = sum(decode_display.(displays))

@show p2
