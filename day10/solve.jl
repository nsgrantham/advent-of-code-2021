function check_syntax(line)
    char_pair = Dict(
        '(' => ')',
        '{' => '}',
        '[' => ']',
        '<' => '>'
    )

    open_chars = Char[]
    close_chars = Char[]
    for (i, char) in enumerate(line)
        if char in keys(char_pair)
            push!(open_chars, char)
            push!(close_chars, char_pair[char])
        else
            if char == close_chars[end]
                pop!(open_chars)
                pop!(close_chars)
            else
                return "corrupt", line[i:end]
            end
        end
    end

    if !isempty(close_chars)
        return "incomplete", join(reverse(close_chars))
    end

    "complete", nothing
end

function score_error(error)
    points = Dict(
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137
    )
    points[error[1]]
end

function score_completion(completion)
    points = Dict(
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4
    )
    score = 0
    for char in completion
        score *= 5
        score += points[char]
    end
    score
end

lines = readlines("day10/lines.txt")
results = check_syntax.(lines)

errors = [error for (status, error) in results if status == "corrupt"]
p1 = sum(score_error.(errors))

@show p1

completions = [completion for (status, completion) in results if status == "incomplete"]
p2 = sort(score_completion.(completions))[convert(Int, ceil(length(completions) / 2))]

@show p2
