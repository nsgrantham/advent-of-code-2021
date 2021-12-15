function parse_polymer(lines)
    template = popfirst!(lines)
    rules = Dict{String, Char}()
    for line in lines
        isempty(line) && continue
        pair, insertion = split(line, " -> ")
        rules[pair] = only(insertion)
    end
    polymer = Dict((pair, 0) for pair in keys(rules))
    for i in 1:length(template) - 1
        polymer[template[i:i + 1]] += 1
    end
    polymer, rules, last(template)
end

function step!(polymer, rules)
    new_polymer = Dict((pair, 0) for pair in keys(polymer))
    for (pair, n) in polymer
        insertion = rules[pair]
        new_polymer[pair[1] * insertion] += n
        new_polymer[insertion * pair[2]] += n
    end
    merge!(polymer, new_polymer)
end

function count_elements(polymer, last_element)
    element_count = Dict{Char, Int}()
    for (pair, n) in polymer
        element_count[pair[1]] = get(element_count, pair[1], 0) + n
    end
    element_count[last_element] += 1  # don't forget to count the last element in polymer
    element_count
end

polymer, rules, last_element = parse_polymer(readlines("day14/polymers.txt"))

for _ in 1:10
    step!(polymer, rules)
end

p1 = -(reverse(extrema(values(count_elements(polymer, last_element))))...)

@show p1

for _ in 1:30  # another 30 steps for a total of 40 steps
    step!(polymer, rules)
end

p2 = -(reverse(extrema(values(count_elements(polymer, last_element))))...)

@show p2
