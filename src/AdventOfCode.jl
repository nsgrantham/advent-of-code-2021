module AdventOfCode

function datapath(parts...)
    normpath(joinpath(@__DIR__, "..", "data", parts...))
end
export datapath

include("Year2021.jl")

end
