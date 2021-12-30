using AdventOfCode
using Test

@testset "Year2021 Day25" begin
    example = "v...>>.vv>
    .vv>>.vv..
    >>.>v>...v
    >>v>>.>.v.
    v>v.vv.v..
    >.>>..v...
    .vv..>.>v.
    v.v..>>v.v
    ....v..v.>"

    @test AdventOfCode.Year2021.Day25.solve(example) == 58
end
