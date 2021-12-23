abstract type AbstractPlayer end

mutable struct Player <: AbstractPlayer
    id::Int
    score::Int
    position::Int
end

mutable struct DeterministicDie
    sides::Int
    value::Int
    rolls::Int
    DeterministicDie(sides) = new(sides, 0, 0)
end

struct Game
    players::Vector{AbstractPlayer}
    winning_score::Int
end

function move!(player::AbstractPlayer, spaces::Int)
    player.position = mod1(player.position + spaces, 10)
    player.score += player.position
    player
end

function roll!(die::DeterministicDie)
    die.rolls += 1
    die.value = mod1(die.value + 1, die.sides)
    die
end

function play!(game::Game, die::DeterministicDie)
    while true
        for player in game.players
            move!(player, sum(roll!(die).value for _ in 1:3))
            player.score >= game.winning_score && return player.id
        end
    end
end

function Base.parse(::Type{Player}, str::String)
    Player(parse(Int, split(str, " ")[2]), 0, parse(Int, last(split(str, ":"))))
end

players = parse.(Player, readlines("day21/start.txt"))
game = Game(players, 1000)
die = DeterministicDie(100)
play!(game, die)

p1 = die.rolls * minimum(player.score for player in game.players)

@show p1

mutable struct MultiversePlayer <: AbstractPlayer
    id::Int
    score::Int
    position::Int
    universes::Int
end

mutable struct DiracDie
    sides::Int
end

function roll3(die::DiracDie)
    outcomes = Dict{Int, Int}()
    for sum_value in [i + j + k for i in 1:die.sides for j in 1:die.sides for k in 1:die.sides]
        outcomes[sum_value] = get(outcomes, sum_value, 0) + 1
    end
    outcomes
end

function play(game::Game, die::DiracDie)
    wins = Dict((player.id, 0) for player in game.players)
    die_outcomes = roll3(die)
    countwins!(wins, game, die_outcomes)
    wins
end

function countwins!(wins::Dict{Int, Int}, game::Game, die_outcomes::Dict{Int, Int})
    player = first(game.players)
    for (sum_value, n) in die_outcomes
        player_copy = move!(copy(player), sum_value)
        player_copy.universes *= n
        if player_copy.score >= game.winning_score
            wins[player_copy.id] += player_copy.universes
        else
            other_player_copy = copy(last(game.players))
            other_player_copy.universes *= n
            countwins!(wins, Game([other_player_copy, player_copy], game.winning_score), die_outcomes)
        end
    end
end

function Base.parse(::Type{MultiversePlayer}, str::String)
    MultiversePlayer(parse(Int, split(str, " ")[2]), 0, parse(Int, last(split(str, ":"))), 1)
end

Base.copy(player::MultiversePlayer) = MultiversePlayer(player.id, player.score, player.position, player.universes)

players = parse.(MultiversePlayer, readlines("day21/start.txt"))
game = Game(players, 21)
die = DiracDie(3)
wins = play(game, die)

p2 = maximum(values(wins))

@show p2
