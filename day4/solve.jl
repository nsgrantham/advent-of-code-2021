numbers = parse.(Int, split(readline("day4/bingo.txt"), ','))

boards = open("day4/bingo.txt") do io
    readline(io)  # remove first line
    readlines(io)
end

boards = filter(!isempty, boards)
boards = permutedims(hcat(split.(boards)...))
boards = parse.(Int, boards)
boards = [boards[i:i+4, :] for i in 1:5:size(boards, 1)]

function play_bingo(numbers, boards)
    bingos = []
    marked_boards = [zeros(Bool, size(board)) for board in boards]
    is_bingo_board = zeros(Bool, length(boards))
    for number in numbers
        for i in eachindex(boards, marked_boards, is_bingo_board)
            is_bingo_board[i] && continue
            board = boards[i]
            marked_board = marked_boards[i]
            for j in eachindex(board, marked_board)
                if board[j] == number
                    marked_board[j] = true
                end
            end
            is_marked_col = sum(marked_board, dims = 1) .== 5
            is_marked_row = sum(marked_board, dims = 2) .== 5
            is_bingo_board[i] = any(is_marked_col) | any(is_marked_row)
            is_bingo_board[i] && push!(bingos, (number, board, marked_board))
        end
    end
    bingos
end

bingos = play_bingo(numbers, boards)

number, board, marked_board = bingos[1]
p1 = number * sum(marked_board[i] ? 0 : board[i] for i in eachindex(board))

@show p1

number, board, marked_board = bingos[end]
p2 = number * sum(marked_board[i] ? 0 : board[i] for i in eachindex(board))

@show p2
