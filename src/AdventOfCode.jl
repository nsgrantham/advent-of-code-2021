module AdventOfCode

function datapath(parts...)
    normpath(joinpath(@__DIR__, "..", "data", parts...))
end

include("Year2021.jl")

end
